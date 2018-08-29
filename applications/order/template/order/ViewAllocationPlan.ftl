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
      <li class="h3">Overview</li>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
    <table class="basic-table form-table" cellspacing="0">
      <tbody>
        <tr>
          <td><label>Name</label></td>
          <td>${allocationPlanInfo.planName!}</td>
          <td><label>Product</label></td>
          <td>${allocationPlanInfo.productId!}</td>
          <td></td>
          <td></td>
          <td><label>Created By</label></td>
          <td>${allocationPlanInfo.createdBy!}</td>
        </tr>
        <tr>
          <td><label>Status</label></td>
          <td>${statusItem.get("description")!}</td>
          <td><label>ATP/QOH</label></td>
          <td>${allocationPlanInfo.totalATP!}/${allocationPlanInfo.totalQOH!}</td>
          <td></td>
          <td></td>
          <td><label>Created Date</label></td>
          <td>${allocationPlanInfo.createdDate!}</td>
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
          <td>${item.partyName!}</td>
          <td>${item.orderId!}</td>
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