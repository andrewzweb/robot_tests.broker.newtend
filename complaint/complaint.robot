** Settings ***
Resource  ../newtend.robot
Resource  complaint_helper.robot
Resource  complaint_cancelled.robot


*** Keywords ***

Create Draft Complaint
  [Arguments]  @{ARGS}
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


Get Info From Complaints
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  # ARG[1] - UA-2021-11-16-000079-d
  # ARG[2] - UA-2021-11-16-000079-d.c1
  # ARG[3] - status
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}

  Find Tender By Id  ${tender_id}
  Go To Complaint

  Log To Console  [+] Get Info From Complaints

  ${complaint_status}=  Get Text  xpath=//div[@class="row question-container"]/div/div/span[@class="status ng-binding"]
  ${result}=  convert_for_robot  ${complaint_status}

  Log To Console  [_] Get Info In Complaint: ${result}
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

  ${username}=  Set Variable  ${ARGS[0]}
  Log To Console  [+] Complaint Publish

  Wait And Click  xpath=//button[@ng-click="publicAsComplaint(complaint.id, complaint.awardId, complaint.qualificationId, complaint.cancellationId)"]


Complaint change status
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Complaint change status

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_id}=  Set Variable  ${ARGS[2]}
  ${complaint_int}=  Set Variable  ${ARGS[3]}
  ${complaint_data}=  Set Variable  ${ARGS[4]}
  ${complaint_status}=  Get From Dictionary  ${complaint_data.data}  status

  Find Tender By Id  ${tender_id}
  Go To Complaint

  Run Keyword If  '${complaint_status}' == 'resolved' and '${username}' == 'Newtend_Owner'  Owner Change Status Complaint
  Run Keyword If  '${complaint_status}' == 'mistaken' and '${username}' == 'Newtend_Provider1'  Provider Change Status Complaint


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


Create Draft Complaint Of Lot
  [Arguments]  @{ARGS}
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


Make Complaint To Qualification
  [Arguments]  @{ARGS}
  Log To Console  [+] Create Complaint To Qualification

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_data}=  Set Variable  ${ARGS[2]}
  ${complaint_data}=  Get From Dictionary  ${complaint_data}  data
  ${Qualification_id}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Go To Auction

  Smart Wait  Wait Until Page Contains Element  xpath=//button[@ng-click="makeComplaint(lotValue.awardId)"]

  Wait And Click  xpath=//button[@ng-click="makeComplaint(lotValue.awardId)"]
  Sleep  2

  Log To Console  ${complaint_data}

  ${complaint_title}=  Get From Dictionary  ${complaint_data}  title
  ${complaint_description}=  Get From Dictionary  ${complaint_data}  description
  ${complaint_type}=  Get From Dictionary  ${complaint_data}  type

  Run Keyword If  '${complaint_type}' == 'complaint'  Wait And Click  xpath=//md-radio-button[@value='complaint']
  Run Keyword If  '${complaint_type}' == 'claim'  Wait And Click  xpath=//md-radio-button[@value='claim']

  Wait And Type  xpath=//input[@ng-model="title"]  ${complaint_title}
  Wait And Type  xpath=//textarea[@ng-model="message"]  ${complaint_description}

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]

  Sleep  10

  # get internal id from browser location string
  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  # make sync on backend
  Sync Tender

  ${complaint}=  Get Complaint Data And Put In Global  ${username}


Make Complaint To Award
  [Arguments]  @{ARGS}
  Log To Console  [+] Create Complaint To Award

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${complaint_data}=  Set Variable  ${ARGS[2]}
  ${complaint_data}=  Get From Dictionary  ${complaint_data}  data
  ${award_id}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Go To Auction

  # подождать пока появится список
  # xpath=//div[@ng-repeat="lotValue in bid.lotValues"]

  # взять данние из апи и пройти по списку доступных бидов и если айди совпадает кликнуть по нему
  # data-lot_bid_id="6c42d508eb034e5caa2de72094afb706"

  Wait And Click  xpath=//button[@ng-click="requirement(awardId)"]

  # заполняем одно поле из имеющихся
  ${complaint_description}=  Get From Dictionary  ${complaint_data}  description
  Wait And Type  xpath=//textarea[@id="description"]  ${complaint_description}

  # нажимаем сохранить жалобу
  Wait And Click xpath=//button[@ng-click="publicRequirement()"]

  Sleep  10

  # get internal id from browser location string
  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10
  # make sync on backend
  Sync Tender

  ${complaint}=  Get Complaint Data And Put In Global  ${username}

  [Return]  ${complaint}  
