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
${tender_id}  UA-2021-11-04-000105-d

*** Test Cases ***

My fast test
  Prapare Browser

  # done
  # Видалити неціновий показник  ${username}  ${tender_id}  f-01

  # process
  ${result}=  Отримати інформацію із нецінового показника  ${username}  ${tender_id}  f-0ff12727  title
  Log To Console  ${result}
  

  # tests
  # Підтвердити кваліфікацію  ${username}  ${tender_id}  1
  # Відхилити кваліфікацію  ${username}  ${tender_id}  2
  # Скасувати кваліфікацію  ${username}  ${tender_id}  2
  # Затвердити остаточне рішення кваліфікації
  
  [Teardown]    Close Browser

*** Keywords ***
Prapare Browser
  Open Browser  https://autotest.newtend.com/  ${BROWSER}
  Set Window Size  1024  764
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

  ${login}=  Set Variable  test.owner@gmail.com
  ${pass}=  Set Variable  testowner0
  Custom Login  ${login}  ${pass}

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


