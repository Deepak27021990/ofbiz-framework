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
            jQuery('#saveItems').attr("href", "javascript:runAction();");
        } else {
            jQuery('#saveItems').attr("href", "javascript: void(0);");
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
            jQuery('#saveItems').attr("href", "javascript:runAction();");
        } else {
            jQuery('#saveItems').attr("href", "javascript: void(0);");
        }
    }
</script>

<#assign statusItem = delegator.findOne("StatusItem", {"statusId" : allocationPlanInfo.statusId!}, false)!/>
<#if !editMode?exists>
    <#assign editMode = false/>
</#if>
<#-- Overview Section -->
<div id="allocationPlanOverview" class="screenlet">
  <div class="screenlet-title-bar">
    <ul>
      <li class="h3">${uiLabelMap.OrderOverview} [${uiLabelMap.CommonId}:${allocationPlanInfo.planId!}]</li>
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
          <td align="right" width="20%">${uiLabelMap.OrderOrderedUnits}</td>
          <td align="right" width="20%">${uiLabelMap.OrderOrderedValue}</td>
          <td align="right" width="20%">${uiLabelMap.OrderAllocatedUnits}</td>
          <td align="right" width="20%">${uiLabelMap.OrderAllocatedValue}</td>
        </tr>
        <#list allocationPlanInfo.summaryMap.keySet() as key>
          <#assign summary = allocationPlanInfo.summaryMap.get(key)/>
          <tr>
            <td>${summary.salesChannel!}</td>
            <td align="right">${summary.orderedUnits!}</td>
            <td align="right">${summary.orderedValue!}</td>
            <td align="right">${summary.allocatedUnits!}</td>
            <td align="right">${summary.allocatedValue!}</td>
          </tr>
        </#list>
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
        <li><a id="saveItems" href="javascript: void(0);" class="buttontext">${uiLabelMap.CommonSave}</a></li>
      <#else>
        <li><a href="/ordermgr/control/EditAllocationPlan?planId=${allocationPlanInfo.planId!}" class="buttontext">${uiLabelMap.CommonEdit}</a></li>
      </#if>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
    <#assign rowCount = 0>
    <form class="basic-form" name="updateAllocationPlanItems" id="updateAllocationPlanItems" method="post" action="<@ofbizUrl>updateAllocationPlanItems</@ofbizUrl>">
      <input type="hidden" name="_useRowSubmit" value="Y" />
      <table class="basic-table hover-bar" cellspacing='0'>
        <tr class="header-row">
          <#if editMode>
            <td width="5%"><input type="checkbox" id="checkAllItems" name="checkAllItems" onchange="javascript:toggleAllItems(this);"></td>
          </#if>
          <td width="10%">${uiLabelMap.OrderSalesChannel}</td>
          <td width="10%">${uiLabelMap.OrderCustomer}</td>
          <td width="10%">${uiLabelMap.FormFieldTitle_orderId}</td>
          <td width="10%">${uiLabelMap.FormFieldTitle_orderItemSeqId}</td>
          <td width="10%">${uiLabelMap.FormFieldTitle_estimatedShipDate}</td>
          <td align="right" width="10%">${uiLabelMap.OrderOrdered}</td>
          <td align="right" width="10%">${uiLabelMap.ProductReserved}</td>
          <td align="right" width="10%">${uiLabelMap.OrderExtValue}</td>
          <td align="right" width="10%">${uiLabelMap.OrderAllocated}</td>
          <#if editMode>
            <td align="center" width="5%">${uiLabelMap.FormFieldTitle_actionEnumId}</td>
          </#if>
        </tr>
        <#list allocationPlanInfo.itemList as item>
          <tr>
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
            <td align="right">${item.orderedUnits!}</td>
            <td align="right">${item.reservedUnits!}</td>
            <td align="right">${item.extValue!}</td>
            <#if editMode>
              <td><input type="text" name="allocatedQuantity_o_${rowCount}" value="${item.allocatedUnits!}"></td>
              <td></td>
            <#else>
              <td align="right">${item.allocatedUnits!}</td>
            </#if>
          </tr>
          <#assign rowCount = rowCount + 1>
        </#list>
      </table>
      <input type="hidden" name="_rowCount" value="${rowCount}" />
    </form>
  </div>
</div>