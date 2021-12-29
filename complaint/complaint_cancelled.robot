** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Cancelled Tender
  [Arguments]  @{ARGS}
  Log To Console  [+] Canceled Tender
  Print Args  @{ARGS}
  # 1 - Newtend_Owner
  # 2 - UA-2021-11-16-000125-d
  # 3 -  c-9488b425: Борозний зніматися пофальшувати мимо ремествувати здирати
  # 4 - expensesCut
  # 5 - /tmp/d-1f36be10atKxhEh9.docx
  # 6 - Осердак голубаня жовтішати різнити усподі чепурніти привіт людино прикриватися.

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_title}=  Set Variable  ${ARGS[2]}
  ${complaint_reason}=  Set Variable  ${ARGS[3]}
  ${complaint_doc}=  Set Variable  ${ARGS[4]}
  ${complaint_description}=  Set Variable  ${ARGS[5]}

  Wait And Click  xpath=//button[@id="cancel-tender-btn"]

  # description
  Wait And Type  xpath=//textarea[@ng-model="reason"]  ${complaint_description}

  # add doc
  Wait And Click  xpath=//div[@ng-model="file"]
  Sleep  2
  Choose File  xpath=//input[@type="file"]  ${complaint_doc}
  Sleep  7

  # reason
  Select From List By Value  xpath=//select[@id="reason"]  ${complaint_reason}

  Wait And Click  xpath=//button[@ng-click="delete()"]

  Sleep  5

  # sing up
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]

  Sleep  5
  
  ${cancellation}=  Get Cancellation Data And Put In Global  ${username}

  ${tender_data}=  newtend_get_tender  ${data.tender_internal_id}
  ${tender_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${tender_data}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender_data}

  [Return]  ${cancellation}


Cancelled Lot
  [Arguments]  @{ARGS}
  Log To Console  [+] Canceled Lot
  # UA-2021-11-09-000268-c
  # l-7812a396
  # c-443f6d22: Душарка победрина кормитися буніти штанці узголов'я сиротюк.
  # noDemand
  # /tmp/d-6e089097quodiQ7vgw.doc
  # Пороспорюватися бісовщина ракляцький утинок соненько воратися ревучий.

  Print Args  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${lot_id}=  Set Variable  ${ARGS[2]}
  ${complaint_title}=  Set Variable  ${ARGS[3]}
  ${complaint_reason}=  Set Variable  ${ARGS[4]}
  ${complaint_doc}=  Set Variable  ${ARGS[5]}
  ${complaint_description}=  Set Variable  ${ARGS[6]}

  Find Tender By Id  ${tender_id}

  # open lot
  Wait And Click  xpath=//h2[@class="tender-block__title tender-block__title--bold ng-binding ng-scope"]
  # click to button open delete lot
  Wait And Click  xpath=//button[@id="cancel-lot-btn"]

  # --- fill form ---
  Wait And Type  xpath=//textarea[@ng-model="reason"]  ${complaint_description}

  # add doc
  Wait And Click  xpath=//div[@ng-model="file"]
  Sleep  2
  Choose File  xpath=//input[@type="file"]  ${complaint_doc}
  Sleep  7

  # choice reason
  Select From List By Value  xpath=//select[@ng-model="reasonType"]  ${complaint_reason}

  Wait And Click  xpath=//button[@ng-click="delete()"]

  Sleep  10

  # sing up
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]

  ${cancellation}=  Get Cancellation Data And Put In Global  ${username}
  Sleep  5
  [Return]  ${cancellation}


Create draft complaint to cancelled tender
  [Arguments]  @{ARGS}
  Log To Console  [+] Make draft complaint

  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_data}=  Set Variable  ${ARGS[2]}
  ${item_index}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  #Go To Complaint
  Sleep  3

  ${lot_button_exitst}=  Run Keyword And Return Status  Get WebElement  xpath=//button[@id="complaint-cancel-lot_0"]
  ${tender_button_exist}=  Run Keyword And Return Status  Get WebElement  xpath=//button[@ng-click="makeComplaint(pendingTenderCancellation.id)"]

  Run Keyword If  ${lot_button_exitst}  Wait And Click  xpath=//button[@id="complaint-cancel-lot_0"]
  Run Keyword If  ${tender_button_exist}  Wait And Click  xpath=//button[@ng-click="makeComplaint(pendingTenderCancellation.id)"]
  Sleep  2

  Log To Console  ${complaint_data}
  
  ${complaint_title}=  Get From Dictionary  ${complaint_data.data}  title
  ${complaint_description}=  Get From Dictionary  ${complaint_data.data}  description
  ${complaint_type}=  Get From Dictionary  ${complaint_data.data}  type

  Run Keyword If  '${complaint_type}' == 'complaint'  Wait And Click  xpath=//md-radio-button[@value='complaint']
  Run Keyword If  '${complaint_type}' == 'claim'  Wait And Click  xpath=//md-radio-button[@value='claim']
  
  Wait And Type  xpath=//input[@ng-model="title"]  ${complaint_title}
  Wait And Type  xpath=//textarea[@ng-model="message"]  ${complaint_description}

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]

  Sleep  5

  # get internal id from browser location string
  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  # make sync on backend
  Sync Tender

  ${complaint}=  Get Complaint Data From Cancelled And Put In Global  ${username}

  [Return]  ${complaint}

Cancel Cancelled Tender
  [Arguments]  @{ARGS}
  Log To Console  [+] Cancel Cancelled Tender
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${canncelled_item}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  Smart Wait  Get WebElement  xpath=//button[@ng-click="recoverTender(pendingTenderCancellation.id)"]

  Wait And Click  xpath=//button[@ng-click="recoverTender(pendingTenderCancellation.id)"]

  Sleep  10

Cancel Cancelled Lot
  [Arguments]  @{ARGS}
  Log To Console  [+] Cancel Cancelled Lot
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${canncelled_item}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  Wait And Click  xpath=//button[@ng-click="recoverTender(pendingTenderCancellation.id)"]

  Sleep  10
