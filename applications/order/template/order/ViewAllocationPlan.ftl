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
    jQuery(document).ready( function() {
        jQuery('#allcheck').change( function() {
            setCheckboxes();
        });

        jQuery('.statuscheck').change( function() {
            setAllCheckbox();
        });
    });

    function setCheckboxes() {
        if (jQuery('#allcheck').is(':checked')) {
            jQuery('.statuscheck').attr ('checked', true);
        } else {
            jQuery('.statuscheck').attr ('checked', false );
        }
    }
    function setAllCheckbox() {
        var allChecked = true;
        jQuery('.statuscheck').each (function () {
            if (!jQuery(this).is(':checked')) {
                allChecked = false;
            }
        });
        if (allChecked == false && jQuery('#allcheck').is(':checked')) {
            jQuery('#allcheck').attr('checked', false);
        }
        if (allChecked == true && !jQuery('#allcheck').is(':checked')) {
            jQuery('#allcheck').attr('checked', true);
        }
    }
</script>

<#assign statusItem = delegator.findOne("StatusItem", {"statusId" : allocationPlanInfo.statusId!}, false)!/>
<#-- Overview Section -->
<div id="allocationPlanOverview" class="screenlet">
  <div class="screenlet-title-bar">
    <ul>
      <li class="h3">Overview [ID:${allocationPlanInfo.planId!}]</li>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
    <table class="basic-table form-table" cellspacing="0">
      <tbody>
        <tr>
          <td align="center"><label><b>Name</b></label></td>
          <td align="left"><a href="/ordermgr/control/ViewAllocationPlan?planId=${allocationPlanInfo.planId!}" title="${allocationPlanInfo.planId!}"> ${allocationPlanInfo.planName!}</a></td>
          <td align="center"><label><b>Product</b></label></td>
          <td align="left"><a href="/catalog/control/EditProduct?productId=${allocationPlanInfo.productId!}" title="${allocationPlanInfo.productId!}">${allocationPlanInfo.productName!}</a></td>
          <td align="center"><label><b>Created By</b></label></td>
          <td align="left">${allocationPlanInfo.createdBy!}</td>
        </tr>
        <tr>
          <td align="center"><label><b>Status</b></label></td>
          <td align="left">${statusItem.get("description")!}</td>
          <td align="center"><label><b>ATP/QOH</b></label></td>
          <td align="left">${allocationPlanInfo.totalATP!}/${allocationPlanInfo.totalQOH!}</td>
          <td align="center"><label><b>Created Date</b></label></td>
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
      <li class="h3">Summary</li>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
      <table class="basic-table hover-bar" cellspacing='0'>
        <tr class="header-row">
          <td width="20%">Ordering Channel</td>
          <td align="right" width="20%">Ordered Units</td>
          <td align="right" width="20%">Ordered Value</td>
          <td align="right" width="20%">Allocated Units</td>
          <td align="right" width="20%">Allocated Value</td>
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
      <li class="h3">Items</li>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
    <table class="basic-table hover-bar" cellspacing='0'>
      <tr class="header-row">
        <td width="5%"></td>
        <td width="10%">Sales Channel</td>
        <td width="10%">Customer</td>
        <td width="10%">Order Id</td>
        <td width="10%">Order Item Seq Id</td>
        <td width="10%">Est. Ship Date</td>
        <td align="right" width="10%">Ordered</td>
        <td align="right" width="10%">Reserved</td>
        <td align="right" width="10%">Ext. Value</td>
        <td align="right" width="10%">Allocated Units</td>
        <td align="center" width="5%">Action</td>
      </tr>
      <#list allocationPlanInfo.itemList as item>
        <tr>
          <td></td>
          <td>${item.salesChannel!}</td>
          <td><a href="/partymgr/control/viewprofile?partyId=${item.partyId!}" title="${item.partyId!}">${item.partyName!}</a></td>
          <td><a href="/ordermgr/control/orderview?orderId=${item.orderId!}" title="${item.orderId!}">${item.orderId!}</a></td>
          <td>${item.orderItemSeqId!}</td>
          <td>${item.estimatedShipDate!}</td>
          <td align="right">${item.orderedUnits!}</td>
          <td align="right">${item.reservedUnits!}</td>
          <td align="right">${item.extValue!}</td>
          <td align="right">${item.allocatedUnits!}</td>
          <td></td>
        </tr>
      </#list>
    </table>
  </div>
</div>