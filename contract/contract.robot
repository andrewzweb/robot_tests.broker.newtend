*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Choise Contract
  [Arguments]  ${contract_number}
  Wait Until Keyword Succeeds  5 minute  30 seconds  Try Choice Contract From Searh List  ${contract_number}

Try Choice Contract From Searh List
  [Arguments]  ${contract_number}
  [*] Try to find Contract
  Reload Page
  ${element_contracts}=  Get WebElements  xpath=//a[@ui-sref="contract.overview({id: contract.id})"]
  Wait And Click  ${element_contracts[${contract_number}]}

Confirm contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Confirm contract

  # confirm contract
  Wait And Type  xpath=button[@id="finish-contract-btn"]

  # click to button save
  Wait And Type  xpath=//button[@ng-click="save()"]

  # singup contract
  SingUp Contract

  # finish contract
  Wait And Type  xpath=//button[@ng-click="terminateContract()"]

Decline contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Decline contract

  ${locator.button_decline}=  Set Variable  xpath=//button[@id="terminate-contract-btn"]
  Wait And Click  ${locator.button_decline}

  # need why you decline
  ${locator.button_decline_description}=  Set Variable  xpath=//input[@name="terminationDetails"]
  Wait And Type  ${locator.button_decline_description}  decline bid why

  # click to button save
  Wait And Click  xpath=//button[@ng-click="save()"]

  # Sing up button
  SingUp Contract

  Wait And Click  xpath=//button[@ng-click="terminateContract()"]

Change contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Change contract

  # open popup edit contract
  Wait And Click  xpath=//button[@ng-click="createChange()"]

  # choise type reason
  ${locator.elements_reason_why_change}=  Set Variable  xpath=//input[@ng-change="collectRationaleTypes()"]
  ${elements_reason}=  Get WebElements  ${locator.elements_reason_why_change}
  Click  ${elements_reason[5]}

  # white reason to change contract
  ${locator.reason_description}=  Set Variable  xpath=//textarea[@ng-model="changes.rationale"]
  Wait And Type  ${locator.reason_description}  my custom rason

  # go to edit
  ${locator.save_reason_and_on}=  Set Variable  xpath=//button[@ng-click="createChange()"]
  Wait And Click  ${locator.save_reason_and_on}

  # wait reload page
  Sleep  5

  # here whould be some variant
  # 1. change price
  # 2. change price with NDS
  # 3. change price by One count

  # after change something
  # save
  ${locator.publish_change_contract}=  Set Variable  xpath=//button[@ng-click="publish(contract)"]
  Wait And Type  ${locator.publish_change_contract}

  # singin contract
  # xpath=//button[@ng-click="sign()"]

  # publick again
  ${locator.publish_change}=  Set Variable  xpath=//button[@ng-click="publicChange()"]
  Wait And Click  ${locator.publish_change}

  # confirm date for publish
  ${locator.confirm_date_publish_change}=  Set Variable  xpath=//button[@ng-click="publicChange(publicData)"]
  Wait And Click  ${locator.confirm_date_publish_change}

Set Date Sing For Contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  # TODO

  # username
  # tender_id - UA-2021-12-12-000085-c
  # contract index - 0
  # date - 2021-12-12T21:22:30.484288+02:00
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${contract_index}=  Set Variable  ${ARGS[2]}
  ${date}=  Set Variable  ${ARGS[3]}

Set Date For Contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}

  # username
  # UA-2021-12-12-000085-c
  # 2021-12-12T21:22:31.900970+02:00
  # 2021-12-12T21:32:31.900970+02:00
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${date_start}=  Set Variable  ${ARGS[2]}
  ${date_end}=  Set Variable  ${ARGS[3]}


Download Document To Contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}

  # username
  # /tmp/d-f38b08e3molestiasV2GIJO.pdf
  # UA-2021-12-12-000085-c
  # 0

  ${username}=  Set Variable  ${ARGS[0]}
  ${document_file}=  Set Variable  ${ARGS[1]}
  ${tender_id}=  Set Variable  ${ARGS[2]}
  ${contract_index}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}

  Go To Auction

  # открыть попап
  Wait And Click  xpath=//button[@data-test_id="upload_contract"]

  # определить тип документа
  Select From List By Index  xpath=//select[@ng-model="document.documentType"]  1

  # нажать на добавить документы
  Wait And Click  xpath=//button[@ng-model="file"]

  # полодить файл
  Choose File  xpath=//input[@type="file"]  ${document_file}

  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");

  Wait And Click  xpath=//button[@ng-click="upload()"]

Create Contract For Negotiation
  Wait And Click  xpath//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]


Create Contract For AgreementsUA Tender
  [Arguments]  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}

  Log To Console  [.] Create Contract For AgreementsUA Tender

  Sleep  60
  Reload Page

  Wait And Click  xpath=//button[@data-test_id="close_qualification"]

  Log To Console  [.] Sleep 16 min
  Sleep  1040
  Log To Console  [+] Sleep 16 min

  ${contract_data}=  api_get_contracts_from_agreeements  ${data.tender_internal_id}
  ${valid_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${contract_data}

  Set To Dictionary  ${USERS.users['${username}']}  agreement_data=${valid_data}
  Log  ${USERS.users['${tender_owner}'].agreement_data}

  Log To Console  [+] Create Contract For AgreementsUA Tender

Set Price For Agreements
  [Arguments]  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  Log To Console  [.] Set Price For Agreements

  Find Tender By Id  ${tender_id}

  Go To Agreements

  Choise Agreement  @{ARGS}

  Set Price  ${agreement_data}

  Log To Console  [+] Set Price For Agreements

Choise Agreement
  [Arguments]  @{ARGS}

  Log To Console  [.] _Choise Agreement

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  Log To Console  ${agreement_data.data}

  # get id what we find
  ${hash_id}=  Get From Dictionary  ${agreement_data.data.suppliers[0]}  name

  Log To Console  [+] Get Agreement User: ${hash_id}

  ${agreement_contract_elements}=  Get WebElements  xpath=//div[@ng-repeat="contract in agreement.contracts track by $index"]
  ${agreement_contract_count}=  Get Length  ${agreement_contract_elements}
  Log To Console  [i] Count Agreement: ${agreement_contract_count}

  :FOR  ${index}  IN RANGE  ${agreement_contract_count}
  \  ${number}=  plus_one  ${index}
  \  ${current_agreement_id}=  Get Text  xpath=//div[@ng-repeat="contract in agreement.contracts track by $index"][${number}]
  \  # Get Element Attribute  xpath=//div[@ng-repeat="contract in agreement.contracts track by $index"][${number}]@data-agreement_id
  \  Log To Console  [i] Current Agreement: ${current_agreement_id}
  \  ${is_need_element}=  is_one_string_include_other_string   ${current_agreement_id}  ${hash_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True  Wait And Click  xpath=//div[@ng-repeat="contract in agreement.contracts track by $index"][${number}]/div/div/button[@ui-sref="tenderView.agreements.one.contracts({contractId: contract.id})"]
  \  Exit For Loop IF  ${is_need_element} == True
  Sleep  5
  Log To Console  [+] _Choise Agreement


Set Price
  [Arguments]  ${agreement_data}

  Log To Console  [.] __Set Price To Agreement
  ${price}=   Get From Dictionary  ${agreement_data.data.unitPrices[0].value}  amount
  ${with_nds}=   Get From Dictionary  ${agreement_data.data.unitPrices[0].value}  valueAddedTaxIncluded

  #${price}=   Set Variable  199
  #${with_nds}=   Set Variable  False

  Wait And Type  xpath=//input[@id="amount"]  ${price}

  Run Keyword If  '${with_nds}' == 'True'  Select Checkbox  xpath=//input[@id="with-nds"]
  Run Keyword If  '${with_nds}' == 'False'  Unselect Checkbox  xpath=//input[@id="with-nds"]

  Wait And Click  xpath=//button[@ng-click="changeUnitPrice()"]

  Log To Console  [+] __Set Price To Agreement


Create Agrements
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  ${start_date}=  Get From Dictionary  ${agreement_data}  startDate
  ${start_date}=  Get Substring  ${start_date}  0  10
  ${end_date}=  Get From Dictionary  ${agreement_data}  endDate
  ${end_date}=  Get Substring  ${end_date}  0  10

  Find Tender By Id  ${tender_id}

  Go To Agreements

  Sleep  3
  Hide Wallet
  
  Wait And Click  xpath=//button[@ng-click="activate()"]

  Wait And Type  xpath=//input[@name="agreementNumber"]  001

  ${inputs}=  Get WebElements  xpath=//input[@ng-model="vm.ngModel"]

  Execute Javascript
  ...  var element=document.querySelector("input[id='input-date-agreement_from']");
  ...  element.removeAttribute("disabled");
  ...  element.removeAttribute("readonly");

  Execute Javascript
  ...  var element=document.querySelector("input[id='input-date-agreement_to']");
  ...  element.removeAttribute("disabled");
  ...  element.removeAttribute("readonly");

    Execute Javascript
  ...  var element=document.querySelector("input[id='input-date-agreement_sign_date']");
  ...  element.removeAttribute("disabled");
  ...  element.removeAttribute("readonly");

  Wait And Type  xpath=//input[@id="input-date-agreement_from"]  ${start_date}
  
  Wait And Type  xpath=//input[@id="input-date-agreement_to"]  ${end_date}

  Wait And Type  xpath=//input[@id="input-date-agreement_sign_date"]  ${start_date}  
  
  ${now}=  Get Current Date
  ${now_hour}=  Get Substring  ${now}  11  13
  ${now_minute}=  Get Substring  ${now}  14  16
  
  Wait And Type  xpath=//input[@ng-change="updateHours()"]  ${now_hour}
  Wait And Type  xpath=//input[@ng-change="updateMinutes()"]  ${now_minute}

  Wait And Click  xpath=//button[@ng-click="submit(true)"]
  Sleep  90

  
