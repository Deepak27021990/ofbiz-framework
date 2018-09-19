<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<script type="application/javascript">
    function toggleAllItems(master) {
        var form = document.updateAllocationPlanItems;
        var length = form.elements.length;
        for (var i = 0; i < length; i++) {
            var element = form.elements[i];
            if (element.name.match(/_rowSubmit_o_.*/)) {
                element.checked = master.checked;
            }
        }
        if (master.checked) {
            jQuery('#saveItemsButton').attr("href", "javascript:runAction();");
        } else {
            jQuery('#saveItemsButton').attr("href", "javascript: void(0);");
        }
    }

    function runAction() {
        var form = document.updateAllocationPlanItems;
        form.submit();
    }

    function toggleItem() {
        var form = document.updateAllocationPlanItems;
        var length = form.elements.length;
        var isAllSelected = true;
        var isAnyOneSelected = false;
        for (var i = 0; i < length; i++) {
            var element = form.elements[i];
            if (element.name.match(/_rowSubmit_o_.*/)) {
                if (element.checked) {
                    isAnyOneSelected = true;
                } else {
                    isAllSelected = false;
                }
            }
        }
        jQuery('#checkAllItems').attr("checked", isAllSelected);
        if (isAnyOneSelected || isAllSelected) {
            jQuery('#saveItemsButton').attr("href", "javascript:runAction();");
        } else {
            jQuery('#saveItemsButton').attr("href", "javascript: void(0);");
        }
    }

    $(document).ready(function(){
        $(".up,.down").click(function(){
            var rowCount = $('#allocatioPlanItemsTable tr').length;
            var row = $(this).parents("tr:first");
            if ($(this).is(".up")) {
                if (row.index() != 1) {
                    row.insertBefore(row.prev());
                }
            } else {
                row.insertAfter(row.next());
            }

            //run through each row and reassign the priority
            $('#allocatioPlanItemsTable tr').each(function (i, row) {
                if (i != 0) {
                    var prioritySeqInput = $(row).find('.prioritySeqId');
                    prioritySeqInput.attr("value", i);
                }
            });
        });
    });
</script>
<#if allocationPlanInfo.allocationPlanHeader?has_content>
  <#assign statusItem = delegator.findOne("StatusItem", {"statusId" : allocationPlanInfo.statusId!}, false)!/>
  <#if !editMode?exists>
      <#assign editMode = false/>
  </#if>
  <#-- Overview Section -->
  <div id="allocationPlanOverview" class="screenlet">
    <div class="screenlet-title-bar">
      <ul>
        <li class="h3">${uiLabelMap.OrderOverview} [${uiLabelMap.CommonId}:${allocationPlanInfo.planId!}]</li>
        <#if allocationPlanInfo.statusId! == "ALLOC_PLAN_CREATED" || allocationPlanInfo.statusId! == "ALLOC_PLAN_APPROVED">
          <li>
            <a href="javascript:document.CancelPlan.submit()">${uiLabelMap.OrderCancelPlan}</a>
            <form class="basic-form" name="CancelPlan" method="post" action="<@ofbizUrl>changeAllocationPlanStatus/orderview</@ofbizUrl>">
              <input type="hidden" name="planId" value="${allocationPlanInfo.planId!}"/>
              <input type="hidden" name="statusId" value="ALLOC_PLAN_CANCELLED"/>
            </form>
          </li>
        </#if>
        <#if allocationPlanInfo.statusId! == "ALLOC_PLAN_APPROVED">
          <li>
            <#if allocationPlanInfo.orderedQuantityTotal == allocationPlanInfo.allocatedQuantityTotal>
              <a href="javascript:document.CompletePlan.submit()">${uiLabelMap.OrderCompletePlan}</a>
              <form class="basic-form" name="CompletePlan" method="post" action="<@ofbizUrl>changeAllocationPlanStatus/orderview</@ofbizUrl>">
                <input type="hidden" name="planId" value="${allocationPlanInfo.planId!}"/>
                <input type="hidden" name="statusId" value="ALLOC_PLAN_COMPLETED"/>
              </form>
            <#else>
              <label title="${uiLabelMap.OrderCannotCompleteAllocationPlan}">${uiLabelMap.OrderCompletePlan}</lable>
            </#if>
          </li>
        </#if>
        <#if allocationPlanInfo.statusId! == "ALLOC_PLAN_CREATED">
          <li>
            <a href="javascript:document.ApprovePlan.submit()">${uiLabelMap.OrderApprovePlan}</a>
            <form class="basic-form" name="ApprovePlan" method="post" action="<@ofbizUrl>changeAllocationPlanStatus/orderview</@ofbizUrl>">
              <input type="hidden" name="planId" value="${allocationPlanInfo.planId!}"/>
              <input type="hidden" name="statusId" value="ALLOC_PLAN_APPROVED"/>
            </form>
          </li>
        </#if>
      </ul>
      <br class="clear"/>
    </div>
    <div class="screenlet-body">
      <table class="basic-table form-table" cellspacing="0">
        <tbody>
          <tr>
            <td align="center"><label><b>${uiLabelMap.CommonName}</b></label></td>
            <td align="left"><a href="/ordermgr/control/ViewAllocationPlan?planId=${allocationPlanInfo.planId!}" title="${allocationPlanInfo.planId!}"> ${allocationPlanInfo.planName!}</a></td>
            <td align="center"><label><b>${uiLabelMap.OrderProduct}</b></label></td>
            <td align="left"><a href="/catalog/control/EditProduct?productId=${allocationPlanInfo.productId!}" title="${allocationPlanInfo.productId!}">${allocationPlanInfo.productName!}</a></td>
            <td align="center"><label><b>${uiLabelMap.CommonCreatedBy}</b></label></td>
            <td align="left">${allocationPlanInfo.createdBy!}</td>
          </tr>
          <tr>
            <td align="center"><label><b>${uiLabelMap.CommonStatus}</b></label></td>
            <td align="left">${statusItem.get("description")!}</td>
            <td align="center"><label><b>${uiLabelMap.ProductAtp}/${uiLabelMap.ProductQoh}</b></label></td>
            <td align="left">${allocationPlanInfo.totalATP!}/${allocationPlanInfo.totalQOH!}</td>
            <td align="center"><label><b>${uiLabelMap.OrderRequestCreatedDate}</b></label></td>
            <td align="left">${allocationPlanInfo.createdDate!}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
  <#-- Summary Section -->
  <div id="allocationPlanSummary" class="screenlet">
    <div class="screenlet-title-bar">
      <ul>
        <li class="h3">${uiLabelMap.CommonSummary}</li>
      </ul>
      <br class="clear"/>
    </div>
    <div class="screenlet-body">
        <table class="basic-table hover-bar" cellspacing='0'>
          <tr class="header-row">
            <td width="20%">${uiLabelMap.OrderOrderingChannel}</td>
            <td align="right" width="16%">${uiLabelMap.OrderOrderedUnits}</td>
            <td align="right" width="16%">${uiLabelMap.OrderOrderedValue}</td>
            <td align="right" width="16%">${uiLabelMap.OrderAllocatedUnits}</td>
            <td align="right" width="16%">${uiLabelMap.OrderAllocatedValue}</td>
            <td align="right" width="16%">${uiLabelMap.OrderAllocation} %</td>
          </tr>
          <#list allocationPlanInfo.summaryMap.keySet() as key>
            <#assign summary = allocationPlanInfo.summaryMap.get(key)/>
            <tr>
              <td>${summary.salesChannel!}</td>
              <td align="right">${summary.orderedQuantity!}</td>
              <td align="right">${summary.orderedValue!}</td>
              <td align="right">${summary.allocatedQuantity!}</td>
              <td align="right">${summary.allocatedValue!}</td>
              <td align="right">${summary.allocationPercentage!}</td>
            </tr>
          </#list>
          <tr>
            <td ><b>${uiLabelMap.CommonTotal}</b></td>
            <td align="right"><b>${allocationPlanInfo.orderedQuantityTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.orderedValueTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.allocatedQuantityTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.allocatedValueTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.allocationPercentageTotal!}</b></td>
          </tr>
        </table>
    </div>
  </div>
  <#-- Items Section -->
  <div id="allocationPlanItems" class="screenlet">
    <div class="screenlet-title-bar">
      <ul>
        <li class="h3">${uiLabelMap.CommonItems}</li>
        <#if editMode>
          <li><a href="/ordermgr/control/ViewAllocationPlan?planId=${allocationPlanInfo.planId!}" class="buttontext">${uiLabelMap.CommonCancel}</a></li>
          <li><a id="saveItemsButton" href="javascript: void(0);" class="buttontext">${uiLabelMap.CommonSave}</a></li>
        <#elseif allocationPlanInfo.statusId! != "ALLOC_PLAN_COMPLETED" && allocationPlanInfo.statusId! != "ALLOC_PLAN_CANCELLED">
          <li><a href="/ordermgr/control/EditAllocationPlan?planId=${allocationPlanInfo.planId!}" class="buttontext">${uiLabelMap.CommonEdit}</a></li>
        </#if>
      </ul>
      <br class="clear"/>
    </div>
    <div class="screenlet-body">
      <#assign rowCount = 0>
      <table id="allocatioPlanItemsTable" class="basic-table hover-bar" cellspacing='0'>
        <form class="basic-form" name="updateAllocationPlanItems" id="updateAllocationPlanItems" method="post" action="<@ofbizUrl>updateAllocationPlanItems</@ofbizUrl>">
          <input type="hidden" name="_useRowSubmit" value="Y" />
          <tr class="header-row">
            <#if editMode>
              <td width="5%"><input type="checkbox" id="checkAllItems" name="checkAllItems" onchange="javascript:toggleAllItems(this);"></td>
            </#if>
            <td width="9%">${uiLabelMap.OrderSalesChannel}</td>
            <td width="9%">${uiLabelMap.OrderCustomer}</td>
            <td width="9%">${uiLabelMap.FormFieldTitle_orderId}</td>
            <td width="9%">${uiLabelMap.FormFieldTitle_orderItemSeqId}</td>
            <td width="9%">${uiLabelMap.FormFieldTitle_estimatedShipDate}</td>
            <td align="right" width="9%">${uiLabelMap.OrderOrdered}</td>
            <td align="right" width="9%">${uiLabelMap.ProductReserved}</td>
            <td align="right" width="9%">${uiLabelMap.OrderExtValue}</td>
            <td align="right" width="9%">${uiLabelMap.OrderAllocated}</td>
            <td align="right" width="9%">${uiLabelMap.OrderAllocation} %</td>
            <#if editMode>
              <td align="right" width="5%">${uiLabelMap.FormFieldTitle_actionEnumId}</td>
            </#if>
          </tr>
          <#list allocationPlanInfo.itemList as item>
            <tr>
              <input type="hidden" name="prioritySeqId_o_${rowCount}" value="${rowCount+1}" class="prioritySeqId"/>
              <input type="hidden" name="planId_o_${rowCount}" value="${item.planId}"/>
              <input type="hidden" name="planItemSeqId_o_${rowCount}" value="${item.planItemSeqId}"/>
              <input type="hidden" name="productId_o_${rowCount}" value="${item.productId}"/>
              <#if editMode>
                <td>
                  <input type="checkbox" name="_rowSubmit_o_${rowCount}" value="Y" onchange="javascript:toggleItem();">
                </td>
              </#if>
              <td>${item.salesChannel!}</td>
              <td><a href="/partymgr/control/viewprofile?partyId=${item.partyId!}" title="${item.partyId!}">${item.partyName!}</a></td>
              <td><a href="/ordermgr/control/orderview?orderId=${item.orderId!}" title="${item.orderId!}">${item.orderId!}</a></td>
              <td>${item.orderItemSeqId!}</td>
              <td>${item.estimatedShipDate!}</td>
              <td align="right">${item.orderedQuantity!}</td>
              <td align="right">${item.reservedQuantity!}</td>
              <td align="right">${item.orderedValue!}</td>
              <#if editMode>
                <td><input type="text" name="allocatedQuantity_o_${rowCount}" value="${item.allocatedQuantity!}"></td>
                <td align="right">${item.allocationPercentage!}</td>
                <td align="right">
                  <a href="#" class="up"><img src="/images/arrow-single-up-green.png"/></a>
                  <a href="#" class="down"><img src="/images/arrow-single-down-green.png"/></a>
                </td>
              <#else>
                <td align="right">${item.allocatedQuantity!}</td>
                <td align="right">${item.allocationPercentage!}</td>
              </#if>
            </tr>
            <#assign rowCount = rowCount + 1>
          </#list>
          <tr>
            <#if editMode>
              <td></td>
            </#if>
            <td colspan="5"><b>${uiLabelMap.CommonTotal}</b></td>
            <td align="right"><b>${allocationPlanInfo.orderedQuantityTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.reservedQuantityTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.orderedValueTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.allocatedQuantityTotal!}</b></td>
            <td align="right"><b>${allocationPlanInfo.allocationPercentageTotal!}</b></td>
            <#if editMode>
              <td></td>
            </#if>
          </tr>
          <input type="hidden" name="_rowCount" value="${rowCount}" />
        </form>
      </table>
    </div>
  </div>
<#else>
  <b>${uiLabelMap.OrderAllocationPlanNotFound}</b>
</#if>