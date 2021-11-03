*** Settings ***
Library  Collections
Library  BuiltIn
Library  String
Library  OperatingSystem
Resource  newtend.robot
#Library   SeleniumLibrary

Library  Selenium2Library
Library  DebugLibrary
Library  Selenium2Screenshots
Library  OperatingSystem

#Library  AppiumLibrary

*** Variables ***
&{D1}    a=1
${username}  Newtend_Owner
${OUTPUT_DIR}  .
${BROWSER}  chrome


*** Test Cases ***
Remove feature
  Open Browser  https://autotest.newtend.com/  ${BROWSER}
  Set Window Size  1024  764
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

  ${login}=  Set Variable  test.owner@gmail.com
  ${pass}=  Set Variable  testowner0
  Custom Login  ${login}  ${pass}

  Видалити неціновий показник  Newtend_Owner  UA-2021-11-03-000366-c  1
  [Teardown]    Close Browser

#My fast test
  #Open Browser  https://autotest.newtend.com/
  #Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

  #${login}=  Set Variable  test.owner@gmail.com
  #${pass}=  Set Variable  testowner0
  #Custom Login  ${login}  ${pass}

  # tests
  #Підтвердити кваліфікацію  Newtend_Owner  UA-2021-11-03-000366-c  1
  #[Teardown]    Close Browser

*** Keywords ***
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

