** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Create Draft Complaint
  [Arguments]  @{ARGS}
  # author:
  # address:
      # countryName: Україна
      # locality: Переяслав-Хмельницький
      # postalCode: '01111'
      # region: Київська область
      # streetAddress: Тестова вулиця, 21-29
  # contactPoint:
      # email: test_e_mail@ukr.net
      # faxNumber: '9998877'
      # name: Другий Тестовий Учасник
      # telephone: '+380506665544'
      # url: http://www.page.gov.ua/
  # identifier:
      # id: '00037256'
      # legalName: Тестове державне управління справами
      # scheme: UA-EDR
  # name: Тестове державне управління справами
  # description: Ошпарити кіска галичина прикриватися попереривати свистіння шквара
  # стереження пахіття цвірінь.
  # title: 'q-cf22398d: Страта мовляти корчити крамарювати.'
  # type: complaint

  Log To Console  [+] Create Draft Complaint

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_data}=  Set Variable  ${ARGS[2]}
  ${complaint_data}=  Get From Dictionary  ${complaint_data}  data

  Find Tender By Id  ${tender_id}
  Go To Complaint

  ${complaint_type}=  Get From Dictionary  ${complaint_data}  type
  #   Run Keyword If  '${complaint_type}' == 'complaint'
  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]
  Sleep  2
  Wait And Click  xpath=//md-radio-button[@value="complaint"]/./div/div

  ${complaint_title}=  Get From Dictionary  ${complaint_data}  title
  ${locator.complaint_title}=  Set Variable  xpath=//input[@ng-model="title"]
  Wait And Type  ${locator.complaint_title}  ${complaint_title}

  Select From List By Value  xpath=//select[@ng-model="complaintOf"]  tender

  ${complaint_description}=  Get From Dictionary  ${complaint_data}  description
  ${locator.complaint_description}=  Set Variable  xpath=//textarea[@ng-model="message"]
  Wait And Type  ${locator.complaint_description}  ${complaint_description}

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]

  Sleep  10

  # get internal id from browser location string
  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  # make sync on backend
  Sync Tender

  ${complaint}=  Get Complaint Data And Put In Global  ${username}

  [Return]  ${complaint}


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

  Sleep  7

  # sing up
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]

  ${cancellation}=  Get Cancellation Data And Put In Global  ${username}
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
  Go To Complaint

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]
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

  #${complaint}=  Get Complaint Data And Put In Global  ${username}

  ${cancellation}=  Get Cancellation Data And Put In Global  ${username}

  [Return]  ${cancellation}


Get Info From Complaints
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  # ARG[1] - UA-2021-11-16-000079-d
  # ARG[2] - UA-2021-11-16-000079-d.c1
  # ARG[3] - status
  ${tender_id}=  Set Variable  ${ARGS[0]}

  Log To Console  [+] Get Info From Complaints

  ${complaint_status}=  Get Text  xpath=//div[@class="row question-container"]/div/div/span[@class="status ng-binding"]
  ${result}=  convert_for_robot  ${complaint_status}

  [Return]  ${result}


Download document to complaint
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  # ARG[0] - Newtend_Provider1
  # ARG[1] - UA-2021-11-15-000304-c
  # ARG[2] - UA-2021-11-15-000304-c.c1
  # ARG[3] - /tmp/d-d2f91020eosJyO7in.docx

  Log To Console  [+] Download document to complaint

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_id}=  Set Variable  ${ARGS[2]}
  ${complaint_doc}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Go To Complaint

  Sleep  3

  Wait And Click  xpath=//button[@ng-click="setComplaintId(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId)"]
  Choose File  xpath=//input[@type="file"]  ${complaint_doc}
  Reload Page
  Sleep  30


Complaint publish
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Complaint Publish

  Wait And Click  xpath=//button[@ng-click="publicAsComplaint(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId)"]


Complaint change status
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Complaint change status

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_id}=  Set Variable  ${ARGS[2]}
  ${complaint_data}=  Set Variable  ${ARGS[3]}
  ${complaint_status}=  Get From Dictionary  ${complaint_data.data}  status

  Find Tender By Id  ${tender_id}
  Go To Complaint

  Run Keyword If  '${complaint_status}' == 'resolved' and '${username}' == 'Newtend_Owner'  Owner Change Status Complaint
  Run Keyword If  '${complaint_status}' == 'mistaken' and '${username}' == Newtend_Provider1  Provider Change Status Complaint


Owner Change Status Complaint
  # open popup  
  Wait And Click  xpath=//button[@ng-click="resolution(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId, true)"]
  Wait And Type  xpath=//textarea[@ng-model="message"]  confirm AMKU resolution for tender owner
  Wait And Click  xpath=//button[@ng-click="sendAnswer()"]
  Sleep  5

    
Provider Change Status Complaint
  # click to cancel complaint 
  Wait And Click  xpath=//button[@ng-click="cancelComplaint(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId, complaint.type)"]
  # input message (need)
  Wait And Type  xpath=//textarea[@ng-model="message"]  cancel complaint description reason write here!!!
  # and confirm action
  Wait And Click  xpath=//button[@ng-click="cancelComplaint()"]
  Sleep  5


Get Complaint Data And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10

  # get complaint data from api
  ${api_complaint_data}=  api_get_complaint  ${data.tender_internal_id}
  # convert complaint data
  ${complaint}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_complaint_data[0]}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
  # convert complaint put in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_data=${complaint}
  [Return]  ${complaint}



Get Cancellation Data And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  
  ${api_cancellation_data}=  api_get_cancellation  ${data.tender_internal_id}
  Log To Console  ${api_cancellation_data}
  # convert complaint data
  ${cancellation}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_cancellation_data}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  cancellation_data=${cancellation}

  [Return]  ${cancellation}


Create Draft Complaint Of Lot
  [Arguments]  @{ARGS}
  # author:
  # address:
      # countryName: Україна
      # locality: Переяслав-Хмельницький
      # postalCode: '01111'
      # region: Київська область
      # streetAddress: Тестова вулиця, 21-29
  # contactPoint:
      # email: test_e_mail@ukr.net
      # faxNumber: '9998877'
      # name: Другий Тестовий Учасник
      # telephone: '+380506665544'
      # url: http://www.page.gov.ua/
  # identifier:
      # id: '00037256'
      # legalName: Тестове державне управління справами
      # scheme: UA-EDR
  # name: Тестове державне управління справами
  # description: Ошпарити кіска галичина прикриватися попереривати свистіння шквара
  # стереження пахіття цвірінь.
  # title: 'q-cf22398d: Страта мовляти корчити крамарювати.'
  # type: complaint

  Log To Console  [+] Create Draft Complaint

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_data}=  Set Variable  ${ARGS[2]}
  ${complaint_data}=  Get From Dictionary  ${complaint_data}  data

  Find Tender By Id  ${tender_id}
  Go To Complaint

  ${complaint_type}=  Get From Dictionary  ${complaint_data}  type
  #   Run Keyword If  '${complaint_type}' == 'complaint'
  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]
  Sleep  2
  Wait And Click  xpath=//md-radio-button[@value="complaint"]/./div/div

  ${complaint_title}=  Get From Dictionary  ${complaint_data}  title
  ${locator.complaint_title}=  Set Variable  xpath=//input[@ng-model="title"]
  Wait And Type  ${locator.complaint_title}  ${complaint_title}

  Select From List By Value  xpath=//select[@ng-model="complaintOf"]  lot

  Select From List By Index  xpath=//select[@ng-model="relatedLot"]  1

  ${complaint_description}=  Get From Dictionary  ${complaint_data}  description
  ${locator.complaint_description}=  Set Variable  xpath=//textarea[@ng-model="message"]
  Wait And Type  ${locator.complaint_description}  ${complaint_description}

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]

  Sleep  10

  # get internal id from browser location string
  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  # make sync on backend
  Sync Tender

  ${complaint}=  Get Complaint Data And Put In Global  ${username}

  [Return]  ${complaint}
