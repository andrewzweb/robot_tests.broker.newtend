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
${tender_id}  UA-2021-11-07-000008-d
@{L2}  1  2  2  3
${date}   2021-11-07T22:59:27.999676+02:00
*** Test Cases ***

#My fast test
  #Prapare Browser

  # done
  # Видалити неціновий показник  ${username}  ${tender_id}  f-01

  # process openeu features get title
  #${result}=  Отримати інформацію із нецінового показника  ${username}  ${tender_id}  f-0ff12727  title
  #Log To Console  ${result}

  # tests openeu pre qulification
  #Підтвердити кваліфікацію  ${username}  ${tender_id}  1
  #Відхилити кваліфікацію  ${username}  ${tender_id}  1
  #Скасувати кваліфікацію  ${username}  ${tender_id}  2
  #Підтвердити кваліфікацію  ${username}  ${tender_id}  2
  #Затвердити остаточне рішення кваліфікації  ${username}  ${tender_id}

  # wait tenter status
  #Find Tender By Id  ${tender_id}
  #Log To Console  [+] Find tender
  #Wait Tender Status  active.pre
  #Log To Console  [+] End

  #Find Tender By Id  ${tender_id}
  #${id}=  Get Internal ID
  #Log To Console  ${id}
  #[Teardown]    Close Browser

#Get Api Test
#  Set Global Variable  ${g_data.current_tender_internal_id}  f5926f5a8d8a4350b7eb92d471729f74
#  ${tender}=  Return Tender Obj  ${g_data.current_tender_internal_id}
#  Log To Console  ${tender['data']['features']}

Convert str to int
    ${numb}=  Set Variable  0.05
    ${result}=  convert_enum_str_to_int  ${numb}
    Log To Console  ${result}

My fast test
  Prapare Browser
  Edit Tender
  # work
  Змінити в тендері поле tenderPeriod.endDate і зберегти  ${date}
  [Teardown]    Close Browser

   
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
  
Remove feature
  Prapare Browser

  Видалити неціновий показник  ${username}  ${tender_id}  1
  [Teardown]    Close Browser


