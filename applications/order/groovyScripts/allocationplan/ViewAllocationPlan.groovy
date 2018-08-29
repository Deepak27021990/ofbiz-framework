/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import org.apache.ofbiz.entity.condition.EntityOperator
import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.order.order.OrderReadHelper
import org.apache.ofbiz.party.party.PartyHelper

planId = parameters.planId
allocationPlanInfo = [:]
allocationPlanHeader = from("AllocationPlanHeader").where("planId", planId).queryFirst()
if (allocationPlanHeader) {
    allocationPlanInfo.planName = allocationPlanHeader.planName
    allocationPlanInfo.statusId = allocationPlanHeader.statusId
    allocationPlanInfo.productId = allocationPlanHeader.productId
    allocationPlanInfo.createdBy = allocationPlanHeader.createdByUserLogin
    allocationPlanInfo.createdDate = allocationPlanHeader.createdStamp

    // inventory quantity summary by facility: For every warehouse the product's ATP and QOH
    // are obtained (calling the "getInventoryAvailableByFacility" service)
    totalATP = 0
    totalQOH = 0
    facilityList = from("ProductFacility").where("productId", allocationPlanHeader.productId).queryList()
    facilityIterator = facilityList.iterator()
    while (facilityIterator) {
        facility = facilityIterator.next()
        result = runService('getInventoryAvailableByFacility', [productId : allocationPlanHeader.productId, facilityId : facility.facilityId])
        totalATP = totalATP + result.availableToPromiseTotal
        totalQOH = totalQOH + result.quantityOnHandTotal
    }
    allocationPlanInfo.totalATP = totalATP
    allocationPlanInfo.totalQOH = totalQOH

    summaryList = []
    itemList = []
    orderedUnitsSummary= [:]
    orderedValueSummary = [:]

    allocationPlanItems = from("AllocationPlanAndItem").where("planId", planId, "productId", allocationPlanInfo.productId).queryList()
    allocationPlanItems.each { allocationPlanItem ->
        summaryMap = [:]
        itemMap = [:]
        orderId = allocationPlanItem.orderId
        orderItemSeqId = allocationPlanItem.orderItemSeqId
        itemMap.orderId = allocationPlanItem.orderId
        itemMap.orderItemSeqId = allocationPlanItem.orderItemSeqId

        orderHeader = from("OrderHeader").where("orderId", orderId).queryOne()
        if (orderHeader) {
            salesChannelEnumId = orderHeader.salesChannelEnumId
            salesChannel = from("Enumeration").where("enumId", salesChannelEnumId).queryOne()
            if (salesChannel) {
                summaryMap.salesChannel = salesChannel.description
                itemMap.salesChannel = salesChannel.description
            }

            orh = new OrderReadHelper(delegator, orderId)
            placingParty = orh.getPlacingParty()
            if (placingParty != null) {
                itemMap.partyId = placingParty.partyId
                itemMap.partyName = PartyHelper.getPartyName(placingParty)
            }

            orderItem = from("OrderItem").where("orderId", orderId, "orderItemSeqId", orderItemSeqId).queryOne()
            unitPrice = 0;
            if (orderItem) {
                unitPrice = orderItem.unitPrice
                cancelQuantity = orderItem.cancelQuantity
                quantity = orderItem.quantity
                if (cancelQuantity != null) {
                    orderedQuantity = quantity.subtract(cancelQuantity)
                } else {
                    orderedQuantity = quantity
                }
                itemMap.orderedUnits = orderedQuantity
 
                if (orderedUnitsSummary.containsKey(salesChannelEnumId)) {
                    existingQuantity = orderedUnitsSummary.get(salesChannelEnumId)
                    orderedUnitsSummary.put(salesChannelEnumId, existingQuantity.add(orderedQuantity))
                } else {
                    orderedUnitsSummary.put(salesChannelEnumId, orderedQuantity)
                }

                orderedValue = orderedQuantity.multiply(unitPrice);
                if (orderedValueSummary.containsKey(salesChannelEnumId)) {
                    existingValue = orderedValueSummary.get(salesChannelEnumId)
                    orderedValueSummary.put(salesChannelEnumId, existingValue.add(orderedValue))
                } else {
                    orderedValueSummary.put(salesChannelEnumId, orderedValue)
                }

                // Reserved quantity
                reservedQuantity = 0.0
                reservations = orderItem.getRelated("OrderItemShipGrpInvRes", null, null, false)
                reservations.each { reservation ->
                    if (reservation.quantity) {
                        reservedQuantity += reservation.quantity
                    }
                }
                itemMap.reservedUnits = reservedQuantity
            }
            allocatedQuantity = allocationPlanItem.allocatedQuantity
            if (allocatedQuantity) {
                summaryMap.allocatedUnits = allocatedQuantity
                itemMap.allocatedUnits = allocatedQuantity
                summaryMap.allocatedValue = (allocatedQuantity).multiply(unitPrice)
            }
            summaryList.add(summaryMap)
        }
        itemList.add(itemMap)
    }
    println "===========orderedUnitsSummary=========="+orderedUnitsSummary
    println "===========orderedValueSummary=========="+orderedValueSummary

    hashMap = [:]
    summaryList.each { summary ->
        if (!hashMap.containsKey(summary.salesChannel)) {
            list = [];
            list.add(summary);
            hashMap.put(summary.salesChannel, list);
        } else {
            hashMap.get(summary.salesChannel).add(summary);
        }
    }

    println "==========summaryList==========="+summaryList
    println "==========hashMap==========="+hashMap
    allocationPlanInfo.summaryList = summaryList
    allocationPlanInfo.itemList = itemList
} else {
    
}
context.allocationPlanInfo = allocationPlanInfo