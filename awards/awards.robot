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

  Sleep  3

  # click confirm
  ${locator.accept_qulification}=  Set Variable  xpath=//*[@ng-click="accept()"]
  Wait Until Element Is Enabled  ${locator.accept_qulification}
  Wait And Click  ${locator.accept_qulification}

Choise Bid
  [Arguments]  ${bid_id}
  Sleep  3
  ${locator.bids}=  Set Variable  xpath=//*[@ng-repeat="bid in tenderBids"]
  ${element_bids}=  Get WebElements  ${locator.bids}
  Wait And Click  ${element_bids[${bid_id}]}
