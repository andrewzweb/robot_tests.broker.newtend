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

  Sleep  600

  ${contract_data}=  api_get_contracts_from_agreeements  ${data.tender_internal_id}
  ${valid_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${contract_data}

  Set To Dictionary  ${USERS.users['${username}']}  agreement_data=${valid_data}
  Log  ${USERS.users['${tender_owner}'].agreement_data}
