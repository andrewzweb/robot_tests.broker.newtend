*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Find Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Find Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}

  #${tender_id}=  Get Substring  ${tender_id}  0  22
  #Find Tender By Id  ${tender_id}

  Go To Agreements
  ${url}=  Get Location
  ${agreement_id}=  Get Agreement From Url  ${url}

  ${path_to_agreement}=  Set Variable  ${HOST}/opc/provider/agreement/${agreement_id}
  Go To  ${path_to_agreement}

  Set Global Variable  ${data.agreement_internal_id}  ${agreement_id}
  
  Save Agreement In Global  ${username}  ${agreement_id}

  Log To Console  [+] ===== Find Agreement =====


Save Agreement In Global
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] __Save Agreement In Global
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}

  ${agreement_data}=  newtend_get_agreement  ${agreement_id}

  ${valid_agreement_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${agreement_data}
  Set To Dictionary  ${USERS.users['${username}']}   agreement_data=${valid_agreement_data}

  Log  ${USERS.users['${username}'].agreement_data}
  Log  ${USERS.users['${username}'].agreement_data.data}
  Log To Console  [+] __Save Agreement In Global: ${agreement_id}

Update Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Update Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  Reload Page 
  Hide Wallet

  ${is_addend}=  Run Keyword And Return Status  Get From Dictionary  ${agreement_data.data.modifications[0]}  addend
  Run Keyword If  ${is_addend}  Log To Console  [ ] Action: addend
  Run Keyword If  ${is_addend}  Update Agreement Addend  ${agreement_data}

  ${is_factor}=  Run Keyword And Return Status  Get From Dictionary  ${agreement_data.data.modifications[0]}  factor
  Run Keyword If  ${is_factor}  Log To Console  [ ] Action: factor
  Run Keyword If  ${is_factor}  Update Agreement Factor  ${agreement_data}

  Sleep  5
  # get form api
  
  Save Agreement In Global  ${username}  ${data.agreement_internal_id}

Update Agreement Addend
  [Arguments]  ${agreement_data}

  Log To Console  [.] __ Update Agreement Addend

  ${addend_value}=  Get From Dictionary  ${agreement_data.data.modifications[0]}  addend
  ${valid_addend_value}=  Convert To String  ${addend_value}
  
  # open popup
  Wait And Click  xpath=//button[@ng-click="vm.openModalPending()"]

  # open accordeon
  Wait And Click  xpath=//div[@ng-click="toogleItemInfo(item, $index)"]
  Sleep  2

  Wait And Type  xpath=//input[@data-test_id="0_changes_uah"]  ${valid_addend_value}

  Wait And Click  xpath=//button[@ng-click="setChanges()"]

  Log To Console  [+] __ Update Agreement Addend


Update Agreement Factor
  [Arguments]  ${agreement_data}
  Log To Console  [.] __ Update Agreement Factor

  ${factor_value}=  Get From Dictionary  ${agreement_data.data.modifications[0]}  factor
  ${valid_factor_value}=  Convert To String  ${factor_value}
  
  # open popup
  Wait And Click  xpath=//button[@ng-click="vm.openModalPending()"]

  # open accordeon
  Wait And Click  xpath=//div[@ng-click="toogleItemInfo(item, $index)"]

  Wait And Type  xpath=//input[@data-test_id="0_changes_percent"]   ${valid_factor_value}

  Wait And Click  xpath=//button[@ng-click="setChanges()"]

  Log To Console  [+] __ Update Agreement Factor

  
Get Info From Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Get Info From Agreement =====
  Print Args  @{ARGS}
  # changes[0].rationaleType
  # changes[0].rationale

Get Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Get Agreement =====
  Print Args  @{ARGS}

  # args1 - username
  # args1 - tender_id


Download Doc In Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Download Doc In Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_doc}=  Set Variable  ${ARGS[1]}
  ${agreement_id}=  Set Variable  ${ARGS[2]}

  Wait And Click  xpath=//button[@ng-click="vm.uploadDocuments(true)"]
  Sleep  2
  Select From List by Value  xpath=//select[@ng-model="document.documentType"]  contractAnnexe

  Wait And Click  xpath=//div[@ng-model="file"]

  Choose File  xpath=//input[@type="file"]  ${agreement_doc}

  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");
  
  Wait And Click  xpath=//button[@ng-click="upload()"]

  Log To Console  [+] __ Download Doc In Agreement

Change Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Add Agreement =====
  Print Args  @{ARGS}

  Log To Console  [.] Test name: ${TEST_NAME}
  
  Run Keyword If  '${TEST_NAME}' == "Можливість внести зміну до угоди partyWithdrawal"  Change Agreement thirdParty  @{ARGS}
  Run Keyword If  '${TEST_NAME}' == "Можливість внести зміну до угоди partyWithdrawal"  Log To Console  [+] its thirdParty

  Run Keyword If  '${TEST_NAME}' != "Можливість внести зміну до угоди partyWithdrawal"  Change Agreement Default  @{ARGS}
  Run Keyword If  '${TEST_NAME}' != "Можливість внести зміну до угоди partyWithdrawal"  Log To Console  [-] its not thirdParty

  Log To Console  \n [+] ===== Add Agreement =====

Change Agreement Default
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  ${agreement_rationale}=  Get From Dictionary  ${agreement_data.data}  rationale
  ${agreement_type}=  Get From Dictionary  ${agreement_data.data}  rationaleType
  ${agreement_rationale_ru}=  Get From Dictionary  ${agreement_data.data}  rationale_en
  ${agreement_rationale_en}=  Get From Dictionary  ${agreement_data.data}  rationale_ru

  Hide Wallet

  Sleep  3

  Wait And Click  xpath=//button[@ng-click="vm.openModal('price')"]
  
  Wait And Type  xpath=//textarea[@ng-model="rationale_ru"]  ${agreement_rationale}
  Wait And Type  xpath=//textarea[@ng-model="rationale_en"]  ${agreement_rationale_en}

  Select From List by Value  xpath=//select[@id="operationType"]  ${agreement_type}

  Wait And Click  xpath=//button[@ng-click="setChanges()"]

  Sleep  5

  Reload Page

  Sleep  5

Change Agreement thirdParty
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  ${agreement_rationale}=  Get From Dictionary  ${agreement_data.data}  rationale
  ${agreement_rationale_ru}=  Get From Dictionary  ${agreement_data.data}  rationale_en
  ${agreement_rationale_en}=  Get From Dictionary  ${agreement_data.data}  rationale_ru

  Hide Wallet

  Sleep  3

  Wait And Click  xpath=//button[@ng-click="vm.openModal('userWithdrawall')"]

  Wait And Type  xpath=//textarea[@ng-model="rationale_ru"]  ${agreement_rationale}
  Wait And Type  xpath=//textarea[@ng-model="rationale_en"]  ${agreement_rationale_en}

  Wait And Click  xpath=//button[@ng-click="setChanges()"]

  Sleep  5

  Reload Page

  Sleep  5
  
    
Apply Chenges Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Apply Chenges Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}
  ${agreement_date}=  Set Variable  ${ARGS[2]}
  ${agreement_status}=  Set Variable  ${ARGS[3]}

  Run Keyword If  '${agreement_status}' == 'active'  Activate Changes  ${agreement_date}
  Run Keyword If  '${agreement_status}' == 'cancelled'  Canceled Changes  ${agreement_date}

  Save Agreement In Global  ${username}  ${data.agreement_internal_id}


Canceled Changes
  [Arguments]  @{ARGS}
  Wait And Click  xpath=//button[@ng-click="vm.cancelChanges()"]
  
Activate Changes
  [Arguments]  @{ARGS}
  # 2022-01-27T22:08:13.176963+02:00	
  Wait And Click  xpath=//button[@ng-click="vm.confirmChanges()"]

  ${agreement_date}=  Set Variable  ${ARGS[0]}
  Log To Console  [ ] Dates: ${agreement_date}

  # TODO
  # Choise data

  Wait And Click  xpath=//button[@ng-click="save()"]

  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  
Get Agreement From Url
  [Arguments]  ${url}
  ${clear_agreement_id}=  Get Substring  ${url}  -32
  Log To Console  [ ] Agreement: ${clear_agreement_id}
  [Return]  ${clear_agreement_id}


Add Doc To Changes
  [Arguments]  @{ARGS}

  # open popup  
  Wait And Click  xpath=//button[@ng-click="vm.uploadDocuments(false)"]

  Select From List by Value  xpath=//select[@ng-model="document.documentType"]  contractAnnexe

  Wait And Click  xpath=//div[@ng-model="file"]

  Choose File  xpath=//input[@type="file"]  ${agreement_doc}

  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");
  
  Wait And Click  xpath=//button[@ng-click="upload()"]
