** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Framework Agreement Tender
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Create Framework Agreement Tender

  Go To Plan And SingUp
  
  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  Wait And Click  ${locator.edit_lot_first}
  
  Add lots  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]

  Sleep  2
  # === It's all in one popup window

  Edit NDS  ${tender_data}

  ${bool_features_exist}=  Exist key in dict  ${tender_data.data}  features
  Run Keyword If  ${bool_features_exist}  Edit Features  ${tender_data}
  
  Edit Date For Tender  ${tender_data}

  Edit Argeement Duration  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable


Create CloseFrameworkAgreementSelectionUA
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] CloseFrameworkAgreementSelectionUA

  ${agreements_id}=  Get From Dictionary   ${tender_data.data.agreements[0]}  id

  ${path_to_agreement}=  Set Variable  ${HOST}/opc/provider/agreement/${agreements_id}
  
  Go To  ${path_to_agreement}

  Hide Wallet
  
  Wait And Click  xpath=//a[@data-test_id="button_createTenderAgreement"]

  ${tender_title}=  Get From Dictionary  ${tender_data.data}  title  
  Wait And Type  xpath=//input[@id="tender-title"]  ${tender_title}

  Wait And Click  xpath=//button[@ng-click="publish()"]

  Sleep  60


  Change EndTender Time In Selection Date

  
  Reload Page

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable
  
  Log To Console  [+] CloseFrameworkAgreementSelectionUA


Change EndTender Time In Selection Date

  ${path_change_tender}=  Set Variable  ${HOST}/opc/provider/tender/${data.tender_internal_id}/edit  

  Go To  ${path_change_tender}
  #Wait And Click  xpath=//a[@id="edit-tender-btn"]

  Sleep  39
  ${date_time_plus_10_min}=  date_now_plus_minutes  25
  ${hour}=  Get Substring  ${date_time_plus_10_min}  11  13
  ${min}=  Get Substring  ${date_time_plus_10_min}  14  16
  Log To Console  [ ] Date NOW: Hour ${hour} | Min: ${min}

  Focus  xpath=//input[@ng-change="updateHours()"]
  Wait And Type  xpath=//input[@ng-change="updateHours()"]  ${hour}
  Wait And Type  xpath=//input[@ng-change="updateMinutes()"]  ${min}

  Wait And Click  xpath=//button[@ng-click="publish()"]
  
  Sleep  39
