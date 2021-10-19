*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Add Quilificaton Comission Document
  [Arguments]  ${document_file}

  Log To Console  [.] Add Quilificaton Comission Document

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

  Log To Console  [+] Add Quilificaton Comission Document

  Sleep  3

Confirm Bid
  # click to popup download
  Log To Console  [.] Confirm bid
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  Wait And Click  ${locator.apply_decision}

  Sleep  2
  ${bid_accept}=  Get WebElement  xpath=//button[@ng-click="accept()"]

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='accept()']");
  ...  element.removeAttribute("disabled");

  Wait And Click  ${bid_accept}
  Log To Console  [+] Confirm bid
  Sleep  2

Choise Bid
  [Arguments]  ${bid_id}
  Log To Console  [+] _ choise number ${bid_id}
  Sleep  3
  ${locator.bids}=  Set Variable  xpath=//*[@ng-repeat="bid in tenderBids"]
  ${element_bids}=  Get WebElements  ${locator.bids}
  Wait And Click  ${element_bids[${bid_id}]}

Finish Torgi
  [Arguments]
  Log To Console  [.] Finish Torgi

  Sleep  30
  Reload Page
  Sleep  15

  ${locator.end_torgi}=  Set Variable  xpath=//button[@data-test_id="close_tender"]
  Wait And Click  ${locator.end_torgi}

  ${locator.input_contract_number}=  Set Variable  xpath=//input[@id="contractNumber"]
  Wait And Type  ${locator.input_contract_number}  0

  # change price
  Wait And Type  id=contractValueAmount  96
  Wait And Type  id=contractValueAmountNet  80
  Wait And Type  id=itemUnitValueAmount  1

  Wait And Click  xpath=//button[@ng-click="closeBids()"]
  Log To Console  [+] Finish Torgi
  Sleep  3
