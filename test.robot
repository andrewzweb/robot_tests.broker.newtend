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
${username}  Newtend_Owner
${OUTPUT_DIR}  .
${BROWSER}  chrome
${tender_id}  UA-2021-11-08-000067-d

@{L2}  1  2  2  3
${date}   2021-11-07T22:59:27.999676+02:00
${g_data.current_tender_internal_id}  551ded127bac4d298d11a5443dd642a2
*** Test Cases ***

Current test
  Prapare Browser
  Qulification test
  [Teardown]    Close Browser
#Test
#  Test Qulification Api

*** Keywords ***
Prapare Browser
  Open Browser  https://autotest.newtend.com/  ${BROWSER}
  Set Window Size  1024  764
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
  #Підтвердити кваліфікацію  ${username}  ${tender_id}  1
  Відхилити кваліфікацію  ${username}  ${tender_id}  2
  #Скасувати кваліфікацію  ${username}  ${tender_id}  2
  #Підтвердити кваліфікацію  ${username}  ${tender_id}  2
  #Затвердити остаточне рішення кваліфікації  ${username}  ${tender_id}

Convert str to int
  ${numb}=  Set Variable  0.05
  ${result}=  convert_enum_str_to_int  ${numb}
  Log To Console  ${result}

Change tenderPeriod.endDate
  Змінити в тендері поле tenderPeriod.endDate і зберегти  ${date}

Get Api Test
  Set Global Variable  ${g_data.current_tender_internal_id}  f5926f5a8d8a4350b7eb92d471729f74
  ${tender}=  Return Tender Obj  ${g_data.current_tender_internal_id}
  Log To Console  ${tender['data']['features']}

Get Internal Id  
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
  ${result}=  api_get_qulification_id_hesh  551ded127bac4d298d11a5443dd642a2  1
  Log To Console  ${result}
  Should Be Equal   ${result}  7b6f154ce8934313ba1b4761696c5f1e
  ${result}=  api_get_qulification_id_hesh  551ded127bac4d298d11a5443dd642a2  2
  Log To Console  ${result}
  Should Be Equal   ${result}  4c16995435be4ba098147281be635b77

Test Get Tender Perion End
  ${result}=  api_get_tenderPeriod_end_date  551ded127bac4d298d11a5443dd642a2
  Log To Console  ${result}
  Should Be Equal   ${result}  2021-11-08T15:34:00+02:00
