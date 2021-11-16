*** Settings ***
Library  Collections
Library  BuiltIn
Library  String
Library  OperatingSystem
Resource  newtend.robot
#Library   SeleniumLibrary

Library  Selenium2Library
Library  DebugLibrary
#Library  Selenium2Screenshots
Library  OperatingSystem

#Library  AppiumLibrary

*** Variables ***
${tender_id}  UA-2021-11-15-000066-d
${data.tender_internal_id}  4f47fd2f5d6a41abacc2d6edd237b008
${username}  Newtend_Owner
${OUTPUT_DIR}  .
${BROWSER}  chrome
@{L2}  1  2  2  3
${date}   2021-11-07T22:59:27.999676+02:00
${question_id}  q-f5a0a31d
*** Test Cases ***

Current test
  Prapare Browser
#  Test Answer to Question
  Test Plan Get Internal Id
  Go To Create OpenEU
  [Teardown]    Close Browser

#Test
#  Test Api Get Complaint Data

#Test
#  Test Qulification Api

*** Keywords ***
Prapare Browser
  Open Browser  https://autotest.newtend.com/  ${BROWSER}
  Set Window Size  1024  764
  Set Window Position  0  0
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

  ${login}=  Set Variable  test.owner@gmail.com
  ${pass}=  Set Variable  testowner0
  Custom Login  ${login}  ${pass}

Edit Tender
  Find Tender By Id  ${tender_id}
  Run Keyword  SingUp Tender
  Sleep  2
  Wait And Click  xpath=//a[@id="edit-tender-btn"]
  
Custom Login
  [ARGUMENTS]   ${login}  ${pass}

  # wait page download
  Wait Until Page Contains Element   ${locator.login_open_modal}  30
  # click to popup
  Click Element   ${locator.login_open_modal}
  Wait Until Element Is Visible  ${locator.login_email_field}
  Wait Until Page Contains Element  ${locator.login_email_field}  30
  # input data
  Click Element   ${locator.login_email_field}
  Input text   ${locator.login_email_field}      ${login}
  Input text   ${locator.login_password_field}   ${pass}
  # button login
  Wait Until Element Is Visible  ${locator.login_action}
  Click Element   ${locator.login_action}
  # Result
  Sleep  3

# ============== end helper =================================
  
Remove feature
  Видалити неціновий показник  ${username}  ${tender_id}  1

Qulification test
  # tests openeu pre qulification
  Підтвердити кваліфікацію  ${username}  ${tender_id}  1
  Відхилити кваліфікацію  ${username}  ${tender_id}  2
  #Скасувати кваліфікацію  ${username}  ${tender_id}  1
  Скасувати кваліфікацію  ${username}  ${tender_id}  2
  Підтвердити кваліфікацію  ${username}  ${tender_id}  2
  Затвердити остаточне рішення кваліфікації  ${username}  ${tender_id}

Convert str to int
  ${numb}=  Set Variable  0.05
  ${result}=  convert_enum_str_to_int  ${numb}
  Log To Console  ${result}

Change tenderPeriod.endDate
  Змінити в тендері поле tenderPeriod.endDate і зберегти  ${date}

Get Api Test
  Set Global Variable  ${data.tender_internal_id}  f5926f5a8d8a4350b7eb92d471729f74
  ${tender}=  Return Tender Obj  ${data.tender_internal_id}
  Log To Console  ${tender['data']['features']}

Test Get Internal ID 
  Find Tender By Id  ${tender_id}
  ${id}=  Get Internal ID
  Log To Console  ${id}

Wait tenter status
  Find Tender By Id  ${tender_id}
  Log To Console  [+] Find tender
  Wait Tender Status  active.pre
  Log To Console  [+] End

Process openeu features get title
  ${result}=  Отримати інформацію із нецінового показника  ${username}  ${tender_id}  f-0ff12727  title
  Log To Console  ${result}

Delete Feature
  Edit tender  
  Видалити неціновий показник  ${username}  ${tender_id}  f-01

Test Qulification Api
  ${result}=  api_get_qulification_id_hesh  b60fc587c07f4d1ebf5e46f22f0bfd4c  1
  Log To Console  ${result}
  Should Be Equal   ${result}  2de2089bcae54f308fa33a4cbac33526
  ${result}=  api_get_qulification_id_hesh  b60fc587c07f4d1ebf5e46f22f0bfd4c  2
  Log To Console  ${result}
  Should Be Equal   ${result}  6dcdb3a7c3c64f5cbf0da447676bb80a

Test Get Tender Perion End
  ${result}=  api_get_tenderPeriod_end_date  551ded127bac4d298d11a5443dd642a2
  Log To Console  ${result}
  Should Be Equal   ${result}  2021-11-08T15:34:00+02:00

Test Get Info From Question
  ${result}=  Get Info From Question  ${username}  UA-2021-11-11-000204-c  q-44f0665b  questions[0].title
  Should Be Equal  ${result}  q-44f0665b: Коханка чудар струпливий шамшити.
  [Return]  ${result}

Test Get Info About Qualification
  ${result}=  Get Info About Qualification  qualifications[0].status  ${username}  ${tender_id}  1
  Should Be Equal   ${result}  active
  Log To Console  ${result}

Test Api Sync Tender
  ${internal_id}=  Set Variable  551ded127bac4d298d11a5443dd642a2
  ${result}=  api_sync_tender  ${internal_id}
  Should Be Equal   ${result}  200
  Log To Console  Response from server ${result}

Test Complaint
  ${tender_id}=  Set Variable  UA-2021-11-12-000254-c
  Find Tender By Id  ${tender_id}
  Go To Complaint

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]
  Wait And Click  xpath=//md-radio-button[@value="complaint"]/./div/div

  ${locator.complaint_title}=  Set Variable  xpath=//input[@ng-model="title"]
  Wait And Type  ${locator.complaint_title}  title

  Select From List By Value  xpath=//select[@ng-model="complaintOf"]  tender


  ${locator.complaint_description}=  Set Variable  xpath=//textarea[@ng-model="message"]
  Wait And Type  ${locator.complaint_description}  complaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_descriptioncomplaint_description

  Wait And Click  xpath=//button[@ng-click="makeComplaint()"]

Test Api Get Complaint Data
    ${result}=  api_get_complaint  ffdf90d5eec548518250a4fc416c4657
    #${data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${result}
    #Log Dictionary  ${data}
    Log To Console  ${result}
    ${id}=  Get From Dictionary  ${result[0]}  complaintID
    Log To Console  ${id}

Test Answer to Question
  Answer to question  ${username}  ${tender_id}  asdfasdfasdfasdfasdf  q-e71cef89  
  
Test Plan Get Internal Id
  ${plan_uaid}=  Set Variable   UA-P-2021-11-16-000294-c
  Find Plan By UAID  ${plan_uaid}
  Sleep  2
  ${result}=  Plan Get Internal Id  -41  -9
  Log To Console  ${result}
  Should Be Equal  ${result}  e1018ccd8e15435794e2ee4b8c0d4515
