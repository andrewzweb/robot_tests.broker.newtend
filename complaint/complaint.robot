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

  # get complaint data from api
  ${api_complaint_data}=  api_get_complaint  ${tedner_internal_id}
  # convert complaint data
  ${complaint}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_complaint_data[0]}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
  # convert complaint put in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_data=${complaint}
  [Return]  ${complaint}


Canceled Lot
  [Arguments]  @{ARGS}
  [Documentation]  Input Data Example
  Log To Console  [+] Canceled Lot
  # UA-2021-11-09-000268-c
  # l-7812a396
  # c-443f6d22: Душарка победрина кормитися буніти штанці узголов'я сиротюк.
  # noDemand
  # /tmp/d-6e089097quodiQ7vgw.doc
  # Пороспорюватися бісовщина ракляцький утинок соненько воратися ревучий.

  ${tender_id}=  Set Variable  @{ARGS[0]}
  ${lot_id}=  Set Variable  @{ARGS[1]}
  ${complaint_id}=  Set Variable  @{ARGS[2]}
  ${reason_decline}=  Set Variable  @{ARGS[3]}
  ${complaint_doc}=  Set Variable  @{ARGS[4]}
  ${complaint_description}=  Set Variable  @{ARGS[5]}


Make draft complaint
  [Arguments]  @{ARGS}
  [Documentation]  Input Data Example
  ... UA-2021-10-28-000287-c
  ... -----------------------
  ... author:
  ...   address:
  ...     countryName: Україна
  ...     locality: Переяслав-Хмельницький
  ...     postalCode: '01111'
  ...     region: Київська область
  ...     streetAddress: Тестова вулиця, 21-29
  ...   contactPoint:
  ...     email: test_e_mail@ukr.net
  ...     faxNumber: '9998877'
  ...     name: Перший Тестовий Учасник
  ...     telephone: '+380506665544'
  ...     url: http://www.page.gov.ua/
  ... identifier:
  ...   id: '21725150'
  ...   legalName: Тестова районна в місті Києві державна адміністрація
  ...   scheme: UA-EDR
  ...   name: Тестова районна в місті Києві державна адміністрація
  ... description: Самопрядка роґлик сужена підставляти знахарювати заглитнутися паливо
  ...   матюнка займати злагідно обрубка.
  ... title: 'q-5d3e106b: Пообскрібати очевидьки клямати кормитися.'
  ... type: complaint
  ... -----------------------
  ... 0

  Log To Console  [+] Make draft complaint

  ${tender_id}=  Set Variable  @{ARGS[0]}
  ${complaint_data}=  Set Variable  @{ARGS[1]}
  ${item_index}=  Set Variable  @{ARGS[2]}


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
  #ARG[0] - Newtend_Provider1
  #ARG[1] - {'description': u'UA-2021-11-16-000081-c.c1-3c9909af [TESTING, ROBOT TESTS]', 'odb_ref': 'TMLN8037M6ZSF.W', 'mfo': '123456', 'currency': 'UAH', 'account': 'UA723004380000026001503374077', 'name': u'\u041f\u043b\u0430\u0442.\u0438\u043d\u0442\u0435\u0440-\u044d\u043a\u0432\u0430\u0439\u0440\u0438\u043d \u0447\u0435\u0440\u0435\u0437 LiqPay', 'okpo': '14360570', 'source': 'account', 'amount': '74760.00', 'date_oper': '16.11.2021 11:01:50', 'type': 'credit'}

  Wait And Click  xpath=//button[@ng-click="publicAsComplaint(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId)"]
