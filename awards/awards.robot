*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Add Doc To Qualification
  [Arguments]  ${username}  ${document_file}  ${tender_id}  ${bid_index}  @{ARGS}
  Log To Console  [+] Add Doc Qulification

  Find Tender By Id  ${tender_id}

  Go To Auction

  Sleep  5

  Choise Bid  ${bid_index}

  Add Quilificaton Comission Document  ${document_file}

  Reload Page

Choise Bid
  [Arguments]  ${bid_index}
  Sleep  2

  ${bid_hash_id}=  api_get_first_award_id  ${data.tender_internal_id}  ${bid_index}
  Log To Console  [+] Get Award ID: ${bid_hash_id}

  ${award_elements}=  Get WebElements  xpath=//div[@ng-repeat="bid in tenderBids"]
  ${award_count}=  Get Length  ${award_elements}
  Log To Console  [i] Count Award: ${award_count}

  :FOR  ${index}  IN RANGE  ${award_count}
  \  ${number}=  plus_one  ${index}
  \  ${current_award_id}=  Get Element Attribute  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]@data-lot_bid_id
  \  Log To Console  [+] Current Award ID: ${current_award_id}
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_award_id}  ${bid_hash_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True  Wait And Click  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]
  \  Exit For Loop IF  ${is_need_element} == True


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


Create Contract
  [Arguments]
  Log To Console  [.] Create Contract

  # click to popup download
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  ${button_exist}=  Run Keyword And Return Status  Get WebElement  xpath=//*[@ng-click="decide('active')"]
  Run Keyword If  ${button_exist}  Wait And Click  ${locator.apply_decision}

  ${locator.end_torgi}=  Set Variable  xpath=//button[@data-test_id="close_tender"]
  Wait Until Keyword Succeeds  5 minute  30 seconds  Wait And Click  ${locator.end_torgi}

  ${locator.input_contract_number}=  Set Variable  xpath=//input[@id="contractNumber"]
  Wait And Type  ${locator.input_contract_number}  0

  # change price
  Wait And Type  id=contractValueAmount  960
  Wait And Type  id=contractValueAmountNet  800

  ${element_value_by_item}=  Get WebElements  id=itemUnitValueAmount
  ${count_items}=  Get Length  ${element_value_by_item}

  : FOR   ${index}  IN RANGE   ${count_items}
  \   ${element}=  Set Variable  ${element_value_by_item[${index}]}
  \   Wait And Type  xpath=//input[@name="${index}_itemUnitValueAmount"]  1

  Wait And Click  xpath=//button[@ng-click="closeBids()"]
  Log To Console  [+] Create Contract
  Sleep  3
