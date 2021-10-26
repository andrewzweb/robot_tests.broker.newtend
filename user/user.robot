** Settings ***
Resource  ../newtend.robot

*** Variables ***
${locator.login_email_field}            id=input_93
${locator.login_password_field}         id=input_94
${locator.login_open_modal}        id=open-enter-modal-btn
${locator.login_action}      xpath=//button[@ng-click="vm.loginUser()"]

*** Keywords ***
Відкрити браузер
  [ARGUMENTS]   @{ARGUMENTS}
  ${alias}=   Catenate   SEPARATOR=   role_    ${ARGUMENTS[0]}
  Set Global Variable   ${BROWSER_ALIAS}   ${alias}
  ${broswer}=  Open Browser
  ...      ${USERS.users[${ARGUMENTS[0]}].homepage}
  ...      ${USERS.users[${ARGUMENTS[0]}].browser}
  ...      alias=${BROWSER_ALIAS}
  [Return]

Встановити розміри браузера
  [ARGUMENTS]   @{ARGUMENTS}
  Set Window Size       @{USERS.users[${ARGUMENTS[0]}].size}
  Set Window Position   @{USERS.users[${ARGUMENTS[0]}].position}
  #Maximize Browser Window

Check user if him reg to login  
  [ARGUMENTS]   ${current_user_type}
  ${viewer_type}=  Set Variable  Newtend_Viewer
  Run Keyword If  '${current_user_type}' != '${viewer_type}'  Login  ${current_user_type}

Login
  [ARGUMENTS]  ${user}  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  #Log To Console  @{ARGUMENTS}
  Log To Console  [+] Login: ${user}

  ${alias}=   Catenate   SEPARATOR=   role_    ${user}
  Set Global Variable   ${BROWSER_ALIAS}   ${alias}

  # wait page download
  Wait Until Page Contains Element   ${locator.login_open_modal}  30
  # click to popup
  Click Element   ${locator.login_open_modal}
  Wait Until Element Is Visible  ${locator.login_email_field}
  Wait Until Page Contains Element  ${locator.login_email_field}  30
  # input data
  Click Element   ${locator.login_email_field}
  Input text   ${locator.login_email_field}      ${USERS.users['${user}'].login}
  Input text   ${locator.login_password_field}   ${USERS.users['${user}'].password}
  # button login
  Wait Until Element Is Visible  ${locator.login_action}
  Click Element   ${locator.login_action}
  # Result
  Sleep  3


Change Language to UKR
  Log To Console  [+] Change Language

  Wait Bar Open
  Sleep  2

  # Change Language to Ukr in the UI
  ${locator.change_language}=  Set Variable  xpath=//a[@ng-click="vm.setLanguage('uk')"]

  # becouse sometimes test drops here and await dont help
  Wait Until Page Contains Element  ${locator.change_language}  
  Focus  ${locator.change_language}
  Click Element  ${locator.change_language}
  Sleep  2

Change user data
  [ARGUMENTS]   @{ARGUMENTS}

  ${company_name}=  Set Variable  Київський Тестовий Ліцей
  # click to dropdown user menu
  ${locator.button_user_dropdown_menu}=  Set Variable  xpath=//div[@ng-if="vm.company.current"]
  Wait Until Page Contains Element  ${locator.button_user_dropdown_menu}
  Wait Until Element Is Visible  ${locator.button_user_dropdown_menu}
  Click Element  ${locator.button_user_dropdown_menu}

  # click to profile settings
  ${locator.button_user_settings}=  Set Variable  xpath=//a[@ui-sref="profile.user"]
  Wait Until Page Contains Element  ${locator.button_user_settings}
  Wait Until Element Is Visible  ${locator.button_user_settings}
  Click Element  ${locator.button_user_settings}

  # change name
  ${locator.field_username}=  Set Variable  xpath=//input[@id="view-first-name"]
  Wait Until Element Is Visible  ${locator.field_username}
  Input Text  ${locator.field_username}  ${company_name}

  # save changes
  ${locator.button_save_username_settings}=  Set Variable  xpath=//button[@ng-click="vm.saveUserProfile()"]
  Wait Until Page Contains Element  ${locator.button_save_username_settings}
  Focus  ${locator.button_save_username_settings}
  Click Element  ${locator.button_save_username_settings}
  Sleep  3

  # click to dropdown user menu
  ${locator.button_user_dropdown_menu}=  Set Variable  xpath=//div[@ng-if="vm.company.current"]
  Wait Until Page Contains Element  ${locator.button_user_dropdown_menu}
  Wait Until Element Is Visible  ${locator.button_user_dropdown_menu}
  Click Element  ${locator.button_user_dropdown_menu}

  # click to company settings
  ${locator.button_company_settings}=  Set Variable  xpath=//md-menu-content/..//a[@ui-sref="profile.company"]
  Wait Until Page Contains Element  ${locator.button_company_settings}
  Wait Until Element Is Visible  ${locator.button_company_settings}
  Click Element  ${locator.button_company_settings}

  # change company name
  ${locator.field_company_name}=  Set Variable  xpath=//input[@ng-model="vm.company.name"]
  Wait Until Page Contains Element  ${locator.field_company_name}
  Wait Until Element Is Visible  ${locator.field_company_name}
  Input Text  ${locator.field_company_name}  ${company_name}

  # save company name
  ${locator.button_save_company_settings}=  Set Variable  xpath=//button[@ng-click="vm.saveCompany()"]
  Wait Until Page Contains Element  ${locator.button_save_company_settings}
  Focus  ${locator.button_save_company_settings}
  Click Element  ${locator.button_save_company_settings}
  Sleep  3

  # go to home page
  #${locator.home_page}=  Set Variable  xpath=//a[@ui-sref="goHome"]
  #Wait Until Page Contains Element  ${locator.home_page}
  #Wait Until Element Is Visible  ${locator.home_page}
  #Click Element  ${locator.home_page}
