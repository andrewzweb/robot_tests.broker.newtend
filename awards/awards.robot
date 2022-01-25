*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Add Doc To Qualification
  [Arguments]  ${username}  ${document_file}  ${tender_id}  ${bid_index}  @{ARGS}
  Log To Console  [+] Add Doc Qulification

  Find Tender By Id  ${tender_id}

  Go To Auction

  Sleep  5

  Choise Bid  ${bid_index}  ${username}

  Add Quilificaton Comission Document  ${document_file}

  Reload Page

Choise Bid
  [Arguments]  ${bid_index}  ${username}
  Sleep  2

  ${tender_type}=  Get Tender Type  ${username}
  ${white_list_of_tenders}=  Create List  esco  competitiveDialogueUA  competitiveDialogueUA  belowThreshold  aboveThresholdEU  aboveThresholdUA  competitiveDialogueEU.stage2  competitiveDialogueUA.stage2

  ${hash_id}=  Run Keyword If  '${tender_type}' in ${white_list_of_tenders}  api_get_bid_id_from_award  ${data.tender_internal_id}  ${bid_index}
  ...   ELSE  api_get_bids_hash  ${data.tender_internal_id}  ${bid_index}

  Log To Console  [+] Get Bid ID: ${hash_id}

  ${bids_elements}=  Get WebElements  xpath=//div[@ng-repeat="bid in tenderBids"]
  ${bids_count}=  Get Length  ${bids_elements}
  Log To Console  [i] Count Award: ${bids_count}

  :FOR  ${index}  IN RANGE  ${bids_count}
  \  ${number}=  plus_one  ${index}
  \  ${current_bid_id}=  Get Element Attribute  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]@data-lot_bid_id
  \  Log To Console  [+] Current Bid ID: ${current_bid_id}
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_bid_id}  ${hash_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True  Wait And Click  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]
  \  Exit For Loop IF  ${is_need_element} == True

Choise Bid By Qualification
  [Arguments]  ${qualification_index}
  Sleep  2

  ${qualification_hash_id}=  api_get_bids_hash  ${data.tender_internal_id}  ${qualification_index}
  Log To Console  [+] Get Bid ID: ${qualification_hash_id}

  ${bids_elements}=  Get WebElements  xpath=//div[@ng-repeat="bid in tenderBids"]
  ${bids_count}=  Get Length  ${bids_elements}
  Log To Console  [i] Count Award: ${bids_count}

  :FOR  ${index}  IN RANGE  ${bids_count}
  \  ${number}=  plus_one  ${index}
  \  ${current_bid_id}=  Get Element Attribute  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]@data-lot_bid_id
  \  Log To Console  [+] Current Bid ID: ${current_bid_id}
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_bid_id}  ${bid_hash_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True  Wait And Click  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]
  \  Exit For Loop IF  ${is_need_element} == True

Add Quilificaton Comission Document
  [Arguments]  ${document_file}

  Log To Console  [.] Add Quilificaton Comission Document

  # click to popup download
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  Wait And Click  ${locator.apply_decision}
  Sleep  3

  # click to add
  Execute Javascript
  ...  var element=document.querySelector("input[data-id='bid_file_update']");
  ...  element.click();

  #${locator.add_file}=  Set Variable  xpath=//input[@data-id="bid_file_update"]
  #Wait And Click  ${locator.add_file}

  # add file
  Sleep  2
  ${locator.input_add_file}=  Set Variable  xpath=//input[@type="file"]
  Choose File  ${locator.input_add_file}  ${document_file}

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");

  ${locator.upload_file}=  Set Variable  xpath=//button[@ng-click="upload()"]
  Wait And Click  ${locator.upload_file}
  
  Sleep  5

  ${locator.close_popup}=  Set Variable  xpath=//div[@class="modal-footer layout-row"]/div[2]/button
  Wait And Click  ${locator.close_popup}

  Log To Console  [+] Add Quilificaton Comission Document

  Sleep  3


Create Contract
  [Arguments]  ${username}
  Log To Console  [.] Create Contract

  # click to popup download
  ${locator.apply_decision}=  Set Variable  xpath=//*[@ng-click="decide('active')"]
  ${button_exist}=  Run Keyword And Return Status  Get WebElement  xpath=//*[@ng-click="decide('active')"]
  Run Keyword If  ${button_exist}  Wait And Click  ${locator.apply_decision}

  # get tender
  Get Tender From Api  ${username}  49  81
  ${tender_type}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data}  procurementMethodType
  Log To Console  [.] type ${tender_type}

  ${locator.end_torgi}=  Run Keyword If  '${tender_type}' == 'closeFrameworkAgreementUA'  Set Variable  xpath=//button[@data-test_id="close_qualification"]
  ...  ELSE  Set Variable  xpath=//button[@data-test_id="close_tender"]

  Wait Until Keyword Succeeds  15 minute  30 seconds  Wait And Click  ${locator.end_torgi}

  ${locator.input_contract_number}=  Set Variable  xpath=//input[@id="contractNumber"]
  Wait And Type  ${locator.input_contract_number}  0

  ${white_list_of_tenders}=  Create List  esco

  # change price
  ${exist_amount}=  Run Keyword And Return Status  Get WebElement  id=contractValueAmount
  Run Keyword If  ${exist_amount} and '${tender_type}' not in ${white_list_of_tenders}   Wait And Type  id=contractValueAmount  960

  ${exist_amountNet}=  Run Keyword And Return Status  Get WebElement  id=contractValueAmountNet
  Run Keyword If  ${exist_amountNet} and '${tender_type}' not in ${white_list_of_tenders}   Wait And Type  id=contractValueAmountNet  800


  ${exist_contractValueAmountNet}=  Run Keyword And Return Status  Get WebElement  id=contractValueAmountNet
  ${is_esco}=  Run Keyword If  '${tender_type}' != 'esco'  Set Variable  True
  ...  ELSE  Set Variable  False
  
  ${element_value_by_item}=  Run Keyword If  ${exist_contractValueAmountNet} and ${is_esco}  Get WebElements  id=itemUnitValueAmount
  ${count_items}=  Run Keyword If  ${exist_contractValueAmountNet} and ${is_esco}  Get Length  ${element_value_by_item}

  Run Keyword If  ${exist_contractValueAmountNet} and '${tender_type}' not in ${white_list_of_tenders}  Edit Price By Item  ${element_value_by_item}  ${count_items}

  Wait And Click  xpath=//button[@ng-click="closeBids()"]
  Log To Console  [+] Create Contract
  Sleep  3

Edit Price By Item
  [Arguments]  ${element_value_by_item}  ${count_items}
  : FOR   ${index}  IN RANGE   ${count_items}
  \   ${element}=  Set Variable  ${element_value_by_item[${index}]}
  \   Wait And Type  xpath=//input[@name="${index}_itemUnitValueAmount"]  0.1


Cancel qualification for owner
  [Arguments]  @{ARGS}

  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${bid_index}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Go To Auction

  ${bid_hash_id}=  api_get_bid_id_from_award  ${data.tender_internal_id}  0
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

  Hide Wallet
  Wait And Click  xpath=//button[@ng-click="cancel('cancelled')"]


Disqualify Award
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Disqualify Award
  
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${bid_index}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Go To Auction


  ${hash_id}=  api_get_bids_hash  ${data.tender_internal_id}  ${bid_index}
  #...   ELSE  api_get_bids_hash  ${data.tender_internal_id}  ${bid_index}

  Log To Console  [+] Get Bid ID: ${hash_id}

  ${bids_elements}=  Get WebElements  xpath=//div[@ng-repeat="bid in tenderBids"]
  ${bids_count}=  Get Length  ${bids_elements}
  Log To Console  [i] Count Award: ${bids_count}

  :FOR  ${index}  IN RANGE  ${bids_count}
  \  ${number}=  plus_one  ${index}
  \  ${current_bid_id}=  Get Element Attribute  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]@data-lot_bid_id
  \  Log To Console  [+] Current Bid ID: ${current_bid_id}
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_bid_id}  ${hash_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True  Wait And Click  xpath=//div[@ng-repeat="bid in tenderBids"][${number}]
  \  Exit For Loop IF  ${is_need_element} == True

  Sleep  3
  
  Hide Wallet
  Wait And Click  xpath=//button[@ng-click="decide('unsuccessful')"]

  Sleep  3
  Select Checkbox  xpath=//input[@id="reason2"]

  Wait And Type  xpath=//textarea[@id="description"]  Reason for decline award.

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='disapprove()']");
  ...  element.removeAttribute("disabled");

  Wait And Click  xpath=//button[@ng-click="disapprove()"]
  
  Sleep  10
