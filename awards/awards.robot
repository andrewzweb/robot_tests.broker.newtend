*** Settings ***
Resource  ../newtend.robot

*** Keywords ***
Add Quilificaton Comission Document
  [Arguments]  ${document_file}

  # click to popup download
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  Wait And Click  ${locator.apply_decision}

  # click to add
  ${locator.add_file}=  Set Variable  xpath=//*[@ng-model="file"]
  Wait And Click  ${locator.add_file}

  # add file
  Sleep  2
  ${locator.input_add_file}=  Set Variable  xpath=//*[@type="file"]
  Choose File  ${locator.input_add_file}  ${document_file}

  ${locator.upload_file}=  Set Variable  xpath=//*[@ng-click="upload()"]
  Wait And Click  ${locator.upload_file}

  Sleep  5

  ${locator.close_popup}=  Set Variable  xpath=//div[@class="modal-footer layout-row"]/div[2]/button
  Wait And Click  ${locator.close_popup}

  Sleep  3

Confirm Bid
  # click to popup download
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  Wait And Click  ${locator.apply_decision}

  Sleep  2
  ${bid_accept}=  Get WebElement  xpath=//button[@ng-click="accept()"]

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='accept()']");
  ...  element.removeAttribute("disabled");

  Wait And Click  ${bid_accept}
  Sleep  2

Choise Bid
  [Arguments]  ${bid_id}
  Log To Console  [+] _ choise number ${bid_id}
  Sleep  3
  ${locator.bids}=  Set Variable  xpath=//*[@ng-repeat="bid in tenderBids"]
  ${element_bids}=  Get WebElements  ${locator.bids}
  Wait And Click  ${element_bids[${bid_id}]}
