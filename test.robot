*** Settings ***
Library  Collections
Library  BuiltIn
Library  String
Library  OperatingSystem
Resource  newtend.robot
Library  Selenium2Library
Library  DebugLibrary
Library  OperatingSystem

*** Variables ***
${tender_id}  UA-2021-11-25-000157-d
${data.tender_internal_id}  0ba2ecac4a034f768a089c585daa98de
${username}  Newtend_Owner
${OUTPUT_DIR}  .
${BROWSER}  chrome
@{L2}  1  2  2  3
${date}   2021-11-07T22:59:27.999676+02:00
${question_id}  q-f5a0a31d
*** Test Cases ***


Test get award
  ${result}=  api_get_first_award_id  0ba2ecac4a034f768a089c585daa98de
  Log To Console  ${result}

Current test
  Prapare Browser
  Add Doc To Qualification  Newtend_Owner  some_file  UA-2021-12-09-000205-c  0
  [Teardown]  Close Browser


*** Keywords ***

Test Qulification Api 2
   ${internal_tender_id}=  Set Variable  9631da687bd54d8dbc88d30bbc5afc5c
   ${qualification_interanl_id}=  api_get_bid_id_hash  ${internal_tender_id}  0
   Log To Console  [+] Get Internal Qualification ID: ${qualification_interanl_id}

Test Qualification Part Get Complaint
  ${data.tender_internal_id}=  Set Variable  5aabe8346b304ac3a2f40edda8400f91
  ${api_complaint_data}=  api_get_complaint_from_qualification  ${data.tender_internal_id}
  ${result}=  Get From Dictionary  ${api_complaint_data[0]}  complaintID
  Log To Console  ${result}

Test Three
  ${procurementMethodType}=  Set Variable  esco
  ${tender_type_with_different_default_count_features}=  Create List  esco  competitiveDialogueUA  competitiveDialogueUA
  Run Keyword If  True and '${procurementMethodType}' not in ${tender_type_with_different_default_count_features}  Log To Console  Not in list
  Run Keyword If  True and '${procurementMethodType}' in ${tender_type_with_different_default_count_features}  Log To Console  In list

Test Complaint From Canncellation
  ${result}=  api_get_complaint_from_cancellation  3007846c90cc421ab6ec9230103b8e3f
  Log To Console  ${result}

Test Get Tender Amount  
  ${result}=  api_get_tender_amount  95c4833e157e4f608862a7db29570458
  Log To Console  ${result}

Complaint get internal id
  Go To  https://autotest.newtend.com/opc/provider/tender/6a997b87052f4d61a3dcf204d9a52fa2/f6bf2c83a6a94d82be7c74e09013214c/a679870e645846c9974d5d077b597e80
  ${result}=  Custom Get Internal ID  -98  -66
  Log To Console  ${result}

Me 2
  ${elements}=  Get Webelements  xpath=//div[@ng-repeat='requirement in requirementGroup.requirements track by $index']

  :FOR  ${element}  IN RANGE  10
  \  Log To Console  ${elements[${element}].get_attribute('id')}
  \  Log To Console  ${elements[${element}].get_attribute('data-requirement_id')}
  # get_attribute('value')

Test Me
  # go to tender
  Find Tender By Id  ${tender_id}

  # click to make bid
  ${locator.button_popup_make_bid}=  Set Variable  xpath=//button[@ng-click="placeBid()"]
  Wait And Click  ${locator.button_popup_make_bid}

  # wait popup
  ${locator.popup_make_bid}=  Set Variable  xpath=//div[@class="modal-content"]
  Wait Until Element Is Visible  ${locator.popup_make_bid}

  # click agree
  ${locator.button_agree_with_publish}=  Set Variable  xpath=//input[@ng-model="agree.value"]
  Select Checkbox  ${locator.button_agree_with_publish}

  # click self qulified
  ${locator.button_agree_selt_quliffied}=  Set Variable  xpath=//input[@ng-model="agree.selfQualified"]
  Select Checkbox  ${locator.button_agree_selt_quliffied}

  # choise from lots
  ${bid_with_lots}=  Run Keyword And Return Status  Get Webelements  xpath=//div[@ng-repeat="lot in lots track by $index"]
  Log To Console  [ ] Bid with criteria: '${bid_with_lots}'

  Log To Console  --- 1 ----
  Run Keyword If  ${bid_with_lots}  Wait And Click  xpath=//button[@ng-show="!lot.lotValue"]

  Log To Console  --- 2 ----
  # есть ставка мультилотовая и у нее есть критерии то нужно эти критериии нажать потомучто дальше мы не
  # не поедем так сказать
  Log To Console  --- 3 ----
  Run Keyword If  ${bid_with_lots}  Wait And Click  xpath=//a[@class="dropdown-toggle ng-binding"]
  Run Keyword If  ${bid_with_lots}  Sleep  2
  Log To Console  --- 6 ----
  Run Keyword If  ${bid_with_lots}  Wait And Click  xpath=//a[@id="feature_item_0_0_0"]
  Log To Console  --- 7 ----


Prapare Browser
  Open Browser  https://autotest.newtend.com/  ${BROWSER}
  Set Window Size  1024  764
  Set Window Position  0  0
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

  ${login}=  Set Variable  test.owner@gmail.com
  ${pass}=  Set Variable  testowner0
  ${login2}=  Set Variable  test.provider1@gmail.com
  ${pass2}=  Set Variable  test.provider1
  Custom Login  ${login2}  ${pass2}

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

Test Bid Amount Convert
  ${amount_raw}=  Set Variable  35 753 280,98  грн
  ${result}=  convert_bid_amount  ${amount_raw}
  Log To Console  ${result}

