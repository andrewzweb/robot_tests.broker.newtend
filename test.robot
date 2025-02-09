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
${tender_id}  UA-2021-12-10-000295-c
${data.tender_internal_id}  7e00551a060a4d4d80a5546eb6e14a78
${username}  Newtend_Owner
${OUTPUT_DIR}  .
${BROWSER}  chrome
@{L2}  1  2  2  3
${date}   2021-11-07T22:59:27.999676+02:00
${question_id}  q-f5a0a31d
${data.plan_id_hash}  f188c1dc156342819b3f437603d65138
${test_data}   9

*** Test Cases ***
Test Me Now
  Prapare Browser
  Test Framework Agreement Selection Change Date
  [Teardown]  Close Browser


*** Keywords ***

Test Framework Agreement Selection Change Date
  Find Tender By Id   UA-2022-02-17-000256-c  
  Change EndTender Time In Selection Date
  

Test Get Agreement Modification
  ${data}=  newtend_get_agreement  8e0afa3d5fd54addb01b35cda4322c61
  Log To Console  ======
  Log To Console  ${data}
  Log To Console  ======

Test agreement path
  ${agreement_id}=  Set Variable  8e0afa3d5fd54addb01b35cda4322c61
  ${path_to_agreement}=  Set Variable  ${HOST}/opc/provider/agreement/${agreement_id}
  Log To Console  ${path_to_agreement}

Test Get Agreement From Url
  Log To Console  kkkkkk
  ${url}=  Set Variable  http://localhost:8000/opc/provider/tender/e96381895d824152884b0d0dded35497/agreements/8e0afa3d5fd54addb01b35cda4322c61
  ${agreement_id}=  Get Agreement From Url  ${url}
  Log To Console  AGREMENT ${agreement_id}
  Should Be Equal  ${agreement_id}  8e0afa3d5fd54addb01b35cda4322c61

Test Framework Agreement Contract Sing
  Go To  http://localhost:8000/opc/provider/tender/ca89936234c34618ac7b520844ad0ead/agreements/ab67c64ba0904b20a0724834ad9db0ec

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

  Wait And Type  xpath=//input[@id="input-date-agreement_from"]  2022-01-27
  
  Wait And Type  xpath=//input[@id="input-date-agreement_to"]  2022-01-27

  Wait And Type  xpath=//input[@id="input-date-agreement_sign_date"]  2022-01-27

  ${now}=  Get Current Date
  ${now_hour}=  Get Substring  ${now}  11  13
  ${now_minute}=  Get Substring  ${now}  14  16
  
  Wait And Type  xpath=//input[@ng-change="updateHours()"]  ${now_hour}
  Wait And Type  xpath=//input[@ng-change="updateMinutes()"]  ${now_minute}
  
  Log To Console  [+] All Done !!!
  Log To Console  [.] Wait You check 15s
  Sleep  10
  Log To Console  [.] Left 5s
  Sleep  5
  
  
Tets Get ID
  ${url_autotest}=  Set Variable  https://autotest.newtend.com/opc/provider/tender/7a40b2d0a7cf49e79e41452601ef6381/overview
  ${url_local}=  Set Variable  http://localhost:8000/opc/provider/tender/7a40b2d0a7cf49e79e41452601ef6381/overview
  
  ${result_local}=  Get Substring  ${url_local}  -41  -9
  ${result_autotest}=  Get Substring  ${url_autotest}  -41  -9

  Should Be Equal  7a40b2d0a7cf49e79e41452601ef6381  ${result_local}
  Should Be Equal  7a40b2d0a7cf49e79e41452601ef6381  ${result_autotest}

Test Change Time In Two Stage
  ${date_time_plus_10_min}=  date_now_plus_minutes  10
  ${hour}=  Get Substring  ${date_time_plus_10_min}  11  13
  ${min}=  Get Substring  ${date_time_plus_10_min}  14  16
  Log To Console  [ ] Hour ${hour} | Min: ${min}

  Focus  xpath=//input[@ng-change="updateHours()"]
  Wait And Type  xpath=//input[@ng-change="updateHours()"]  ${hour}
  Wait And Type  xpath=//input[@ng-change="updateMinutes()"]  ${min}

Tets Choise Agreement
  ${tender_id}=  Set Variable  UA-2022-01-17-000056-d

  Find Tender By Id  ${tender_id}
  Go To Agreements
  Choise Agreement  username  tender_id  agreements_data
  Set Price  some_data

Test Get Contract From Agreements
  Set Global Variable  ${data.tender_internal_id}  83859f1914dd49659684a325a4fd1297
  ${data}=  api_get_contracts_from_agreeements  ${data.tender_internal_id}
  Log To Console  ${data}

Tets Get Agreements Data
  Set Global Variable  ${data.tender_internal_id}  83859f1914dd49659684a325a4fd1297
  ${data}=  api_get_agreements_from_tender  ${data.tender_internal_id}
  Log To Console  ${data}

Test check status
  ${test_suit_name}=  Set Variable  Tests Files.03Contract Signing
  Run Keyword If  'Contract Signing' in '${test_suit_name}'  Log To Console  [+] Contract wait
  Run Keyword If  'contract_signing' in '${test_suit_name}'  Log To Console  [+] Contract wait 2

Test Multiplu w2
  ${numb}=  Set Variable  0.12345
  ${result}=  multiply_float_and_return_string  ${numb}
  Log To Console  ${result}


Test Write Minimal
  ${numb}=  Set Variable  0.02376
  ${data_key}=  multiply_float_and_return_string  ${numb}

  Go To  https://autotest.newtend.com/opc/provider/create-tender/multilot/esco/plan/72ee79ca009a4cff8f6f1404b1226af7
  Wait And Click  xpath=//input[@id="lot-id-0"]
  Wait And Type  ${locator.edit_lot_minimalStepPercentage}  ${data_key}
  Sleep  15

Test AND statement

  ${length_args}=  Set Variable  5
  
  Run Keyword If  ${length_args} == 5  Run Keywords
  ...  Log To Console  1
  ...  AND  Log To Console  2
  ...  AND  Log To Console  3
    
Test Cancel Cancelled Tender
  ${username}=  Set Variable  Newtend_Owner
  ${tender_id}=  Set Variable  UA-2022-01-06-000087-d

  Cancel Cancelled Tender  ${username}  ${tender_id}  0

    
Test Multiplu w
  ${numb}=  Set Variable  0.12345
  ${result}=  multiply_float_and_return_string  ${numb}
  Log To Console  ${result}
  
Test Esco Bid

  Go To  https://autotest.newtend.com/opc/provider/tender/cca2e90855af45a186eba8cb720fa067/overview

  Sleep  4
  Wait And Click  xpath=//button[@ng-click="placeBid()"]

  ${locator.button_agree_with_publish}=  Set Variable  xpath=//input[@ng-model="agree.value"]
  Select Checkbox  ${locator.button_agree_with_publish}

  # click self qulified
  ${locator.button_agree_selt_quliffied}=  Set Variable  xpath=//input[@ng-model="agree.selfQualified"]
  Select Checkbox  ${locator.button_agree_selt_quliffied}

  Wait And Click  xpath=//button[@ng-show="!lot.lotValue"]

  ${annualCostsReduction}=  Create List  11.12  1  2  3  4
  ${length_annualCostsReduction}=  Get Length  ${annualCostsReduction}
  
  :FOR  ${item}  IN RANGE  ${length_annualCostsReduction}
  \  ${numb}=  Convert To String  ${item}
  \  ${status}=  Run Keyword And Return Status  Clear Element Text  xpath=//input[@id="acr-${numb}"]
  \  ${number}=  Convert To String  ${annualCostsReduction[${item}]}
  \  Log To Console  ${number}
  \  ${status}=  Run Keyword And Return Status  Input Text  xpath=//input[@id="acr-${numb}"]  ${number}
  \  Log To Console  [${status}] ${annualCostsReduction[${item}]}
  \  Sleep  1

  
Test Get Budget Amount
  ${tender_id}=  Set Variable  UA-2021-12-30-000223-c
  Find Tender By Id  ${tender_id}
  ${result}=  Отримати інформацію із пропозиції із поля lotValues[0].value.amount  1

  Log To Console  ${result}
  
Test Get Doc From CDB

  ${username}=  Set Variable  Newtend_Owner
  ${tender_id}=  Set Variable  UA-2021-12-30-000072-d
  ${document_title}=  Set Variable  d-9dc52187

  ${result}=  Отримати документ  ${username}  ${tender_id}  ${document_title}
  Log To Console  ${result}

  
Test Get Internal ID From URL
    ${url}=  Set Variable  https://autotest.newtend.com/opc/provider/tender/0fd4828ff78b4fc8b8ca217194e10af0/auction
    ${result}=  Get Substring  ${url}  49  81
    Log To Console  ${result}
    Should Be Equal   ${result}  0fd4828ff78b4fc8b8ca217194e10af0

Test Add Doc To Qualification
  Set Global Variable  ${data.internal_tender_id}  48836fc1bd6f4d81acddbebd7dc540f0
  ${username}=  Set Variable  username
  ${document_file}=  Set Variable  /home/andrew/workspace/work/robot_tests/test.txt
  ${tender_id}=  Set Variable  UA-2021-12-29-000080-d
  ${bid_index}=  Set Variable  0
  
  Add Doc To Qualification  ${username}  ${document_file}  ${tender_id}  ${bid_index}


Test Cancel Qulification From Owner

  Set Global Variable  ${internal_tender_id}  c0a9f50e10554a5386dd6b56675971ac
  ${username}=  Set Variable  NewTend_Owner
  ${tender_id}=  Set Variable  UA-2021-12-28-000133-d
  ${bid_index}=  Set Variable  0

  Cancel qualification for owner  ${username}  ${tender_id}  ${bid_index}

Test Get File From Cbd
  ${url}=  Set Variable  https://public-docs-staging.prozorro.gov.ua/get/9c11c74ebcb444789e8b41e41ee32238?Signature=HXw0hzSmXYuA4fZ%2FbwoOAzy32xtoilL6aKpXBkpT2lmqikhpU5IaM3JaC51ytXBmVPBk9n0di%2BM5Hb0bx%2B85CA%3D%3D&KeyID=01b985cf
  ${result}=  get_doc_from_cbd  ${url}
  Log To Console  ${result}
  
Test Get Text From File
  ${username}=  Set Variable  Owner
  ${tender_id}=  Set Variable  UA-2021-12-23-000106-c
  ${question_id}=  Set Variable  d-d0b72684
  
  ${result}=  Отримати документ  ${username}  ${tender_id}  ${question_id}
  Log To Console  ${result}

Test Get Title From Question
  ${username}=  Set Variable  Owner
  ${tender_id}=  Set Variable  UA-2021-12-23-000106-c
  ${question_id}=  Set Variable  d-d0b72684
  ${search_field}=  Set Variable  title
  
  ${result}=  Отримати інформацію із документа  ${username}  ${tender_id}  ${question_id}  ${search_field}
  Log To Console  ${result}
  
Test Git Info
  ${info}=  update_repo
  Log To Console  ${info}
    
Test Plan 
  Log To Console  ${data.plan_id_hash}
  ${plan_data}=  get_plan_data_from_cbd  ${data.plan_id_hash}
  Log To Console  ${plan_data}
  #${data}=  Get From Dictionary  ${plan_data.data}  items
  #${data}=  Get From Dictionary  ${data}  items[0]
  #${data}=  Get From Dictionary  ${data}  items

  Log To Console  ${data}
     
Test Multiplu
  ${numb}=  Set Variable  0.01255  
  ${new}=  multiply_float_and_return_string  ${numb}
  Log To Console  ${new}

Test Find Tender
  Find Tender By Id  ${tender_id}  ${username}

Test Black List Check
  ${type}=  Set Variable  esco
  ${type}=  Convert To String  ${type}
  ${list}=  black_list_tender_for_feature
  ${result}=  str_in_list  ${type}  ${list}  
  Log To Console  [${result}] Type

Test Black Two
  ${type}=  Set Variable  esco
  ${type}=  Convert To String  ${type}
  ${list}=  black_list_tender_for_feature  
  ${result}=  List Should Contain Value  ${list}  ${type}
  Log To Console  [${result}] Type
  
Test Black Two Tvise
  ${type}=  Set Variable  esco
  ${type}=  Convert To String  ${type}
  ${list}=  black_list_tender_for_feature  
  ${result}=  Run Keyword If  '${type}' in ${list}  Log To Console  [True] Type
  
  
Test UI Feature
  ${page}=  Set Variable  https://autotest.newtend.com/opc/provider/create-tender/multilot/competitiveDialogueEU/plan/951cb32a01ec4ccead51d55abe61b398
  Go To  ${page}

  Wait And Click  xpath=//input[@id="qualityIndicator"]

  ${procurementMethodType}=  Set Variable  esco
  
  ${tender_type_with_different_default_count_features}=  black_list_tender_for_feature 

  ${status_speciat_tender}=  str_in_list  ${procurementMethodType}  ${tender_type_with_different_default_count_features}  msg=True
  Log To Console  [${status_speciat_tender}] Tender in black list
  Run Keyword If  ${status_speciat_tender}  Wait And Click  xpath=//a[@id="add-option-0-1"]

  ${count_enum}=  Set Variable  3
  
  : FOR   ${number_enum}  IN RANGE   ${count_enum}
  \  ${num_enum}=  Convert To Integer  ${number_enum}
  \  ${edit_feature_enum_title}=  Get WebElement  xpath=//input[@name="option_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_title}  ${number_enum}
  \  ${edit_feature_enum_value}=  Get WebElement  xpath=//input[@name="optionWeight_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_value}  ${number_enum}
  \  ${edit_feature_enum_description}=  Get WebElement  xpath=//input[@name="optionDescription_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_description}  ${number_enum}
  \  # add one form
  \  #
  \  ${st1}=  Evaluate  ${number_enum} < ${count_enum}-1
  \  
  \  #Log To Console  ${num_enum}: ${st1} | ${status_speciat_tender}
  \  #Log To Console  ${procurementMethodType} | ${tender_type_with_different_default_count_features}
  \
  \  Run Keyword If  ${st1} and not ${status_speciat_tender}  Wait And Click  xpath=//a[@id="add-option-0-${number_enum}"]

  # click to save features
  Wait And Click  ${locator.edit_feature_save_form}

Test Feature

  ${tender_type_with_different_default_count_features}=  Create List  esco  competitiveDialogueUA  competitiveDialogueUA
  ${procurementMethodType}=  Set Variable  esco

  ${count_enum}=  Set Variable  3

  : FOR   ${number_enum}  IN RANGE   ${count_enum}
  \  ${num_enum}=  Convert To Integer  ${number_enum}
  \
  \  Log To Console  --------------------
  \  ${st1}=  Evaluate  ${number_enum} < ${count_enum}-1
  \  ${st2}=  str_in_list  ${procurementMethodType}  ${tender_type_with_different_default_count_features}
  \
  \  Log To Console  ${num_enum}: [${st1}] [${st2}]
  \
  \  Run Keyword If  ${st1} and not ${st2}  Log To Console  ==== First ====
  \  # if esco we have 2 open form we need 3
  \  Run Keyword If  ${st2} and not ${st1}  Log To Console  ==== Second ====


Qulification test
  # tests openeu pre qulification
  Підтвердити кваліфікацію  ${username}  ${tender_id}  0
  Відхилити кваліфікацію  ${username}  ${tender_id}  1
  #Скасувати кваліфікацію  ${username}  ${tender_id}  1
  Скасувати кваліфікацію  ${username}  ${tender_id}  1
  Підтвердити кваліфікацію  ${username}  ${tender_id}  2
  #Затвердити остаточне рішення кваліфікації  ${username}  ${tender_id}

Test get award
  Log To Console  -----------
  ${result}=  api_get_bid_id_hash  ${data.tender_internal_id}  0
  Log To Console  -----------
  Log To Console  0: ${result}
  ${result}=  api_get_bid_id_hash  ${data.tender_internal_id}  1
  Log To Console  -----------
  Log To Console  1: ${result}
  ${result}=  api_get_bid_id_hash  ${data.tender_internal_id}  2
  Log To Console  -----------
  Log To Console  2: ${result}
  ${result}=  api_get_bid_id_hash  ${data.tender_internal_id}  -1
  Log To Console  -----------
  Log To Console  3: ${result}
  ${result}=  api_get_bid_id_hash  ${data.tender_internal_id}  -2
  Log To Console  -----------
  Log To Console  4: ${result}


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
  #${HOST_STAGE}=  Set Variable  https://autotest.newtend.com/
  ${HOST_LOCAL}=  Set Variable  http://localhost:8000/
  ${HOST}=  Set Variable  ${HOST_LOCAL}
  Open Browser  ${HOST}  ${BROWSER}
  Set Window Size  1024  764
  Set Window Position  0  0
  #Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2022-11-30 16:21:35
  #Add Cookie  autotest  1  domain=localhost:8000  expiry=2022-11-30 16:21:35
  #Add Cookie  autotest  1  domain=localhost  expiry=2022-11-30 16:21:35

  ${owner_local_login}=  Set Variable  newtend.owner@gmail.com
  ${owner_local_pass}=  Set Variable  testowner
  ${owner_stage_login}=  Set Variable  test.owner@gmail.com
  ${owner_stage_pass}=  Set Variable  testowner0
  ${provider_stage_login}=  Set Variable  test.provider1@gmail.com
  ${provider_stage_pass}=  Set Variable  test.provider1

  Run Keyword If  '${HOST}' == '${HOST_LOCAL}'  Custom Login  ${owner_local_login}  ${owner_local_pass}
  ...  ELSE  Custom Login  ${owner_local_login}  ${owner_stage_login}  ${owner_stage_pass}


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

