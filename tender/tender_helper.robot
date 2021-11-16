*** Settings ***
Library  String
Library  ../helper/newtend_service.py

*** Keywords ***

Опубліковати тендер
  [Tags]  helper
  Wait Until Page Contains Element    xpath=//button[@ng-click="publish()"]
  Focus    xpath=//button[@ng-click="publish()"]
  Click Element    xpath=//button[@ng-click="publish()"]

Найти ключ в директории
  [Arguments]  ${path}
  @{current_name_files_list}=  List Files In Directory  ${path}/payload_data
  ${result}=  Set Variable  result
  ${pattert}=  Set Variable  .jks
  :FOR  ${name_file}  IN  @{current_name_files_list}
  \  ${valid}=  is_one_string_include_other_string  ${name_file}  ${pattert}
  \  ${result}=  Run Keyword If  ${valid} == True  Convert To String  ${name_file}
  [Return]  ${result}

Set Date Time
  [Arguments]  ${locator}  ${date}

  ${date_day}=  Get Substring   ${date}   0    10
  ${date_hour}=  Get Substring   ${date}   11   13
  ${date_minute}=  Get Substring   ${date}   14   16

  # input date
  ${string_id_locator}=  Get Substring  ${locator}  19  -2
  Execute Javascript    window.document.getElementById('${string_id_locator}').removeAttribute("readonly")
  Input Text  ${locator}  ${date_day}

  # input hour
  ${tenderingEnd_date_hours}=  Get Webelement  xpath=//label[@for="${string_id_locator}"]/..//input[@ng-change="updateHours()"]
  Input Text  ${tenderingEnd_date_hours}  ${date_hour}

  # input minute
  ${tenderingEnd_date_minutes}=  Get Webelement  xpath=//label[@for="${string_id_locator}"]/..//input[@ng-change="updateMinutes()"]
  Input Text  ${tenderingEnd_date_minutes}  ${date_minute}

Перейти на страницу создания сущности
  [Arguments]  ${entity_type}  ${kind_type}
  # click to button create
  ${locator.button_create_tender_or_plan}=  Set Variable  xpath=//button[@id="create-menu"]
  Wait Until Page Contains Element  ${locator.button_create_tender_or_plan}
  Wait Until Element Is Visible  ${locator.button_create_tender_or_plan}
  Click Element  ${locator.button_create_tender_or_plan}

  # choice create tender
  ${locator.link_create_tender}=  Set Variable  xpath=//a[contains(., "Створити закупівлю")]
  Wait Until Element Is Visible  ${locator.link_create_tender}
  Click Element  ${locator.link_create_tender}

  # wait until modal show
  Wait Until Element Is Visible  xpath=//div[@id="tender-procedure-modal"]

  # click to dropdown menu type tender
  ${locator.select_choice_type_tender}=  Set Variable  xpath=//md-select[@ng-model="vm.tenderProcedure"]
  Wait Until Element Is Visible  ${locator.select_choice_type_tender}
  Sleep  2
  Focus  ${locator.select_choice_type_tender}
  Click Element  ${locator.select_choice_type_tender}

  # choise needed type tender
  Wait Until Page Contains Element  xpath=//md-option[@ng-if="vm.alowedMethodTypes.${kind_type}"]
  Click Element  xpath=//md-option[@ng-if="vm.alowedMethodTypes.${kind_type}"]
  Sleep  2

  # choice singlelot or multilot
  ${locator.checkbox_tender_singlelot}=  Set Variable  xpath=//md-radio-button[@class="primary"]
  Wait Until Element Is Visible    ${locator.checkbox_tender_singlelot}
  Focus    ${locator.checkbox_tender_singlelot}
  Click Element    ${locator.checkbox_tender_singlelot}

  # click button create tender
  ${locator.button_create_entity}=  Set Variable  button[ng-click="vm.createTender(vm.tenderProcedure, vm.tenderLots)"]
  Wait Until Element Is Visible    ${locator.button_create_entity}
  Click Element  ${locator.button_create_entity}


SingUp Entity
  # go in widget singup
  Wait Until Page Contains Element  ${locator.singup_frame}
  Select Frame  ${locator.singup_frame}

  ### put key
  # get path to this file and separete folder
  ${path_to_root_submodule}=  Get Substring  ${CURDIR}  0  -6
  # get list files from payload folder

  ${data.key_name}=  Найти ключ в директории  ${path_to_root_submodule}
  ${key_file_path}=  Set Variable  ${path_to_root_submodule}/payload_data/${data.key_name}

  # valid name
  ${data.len_key_file_name}=  Get Length  ${data.key_name}
  ${valid_key_name}=  Get Substring  ${key_file_path}  -${data.len_key_file_name}  -1


  # wait
  Sleep  2
  Wait Until Page Contains Element  ${locator.singup_upload_key_file}
  # make field changeble
  Execute Javascript    window.document.getElementById("pkReadFileTextField").removeAttribute("readonly")
  # check file exist
  File Should Exist  ${key_file_path}
  # input file name
  Input Text  ${locator.singup_upload_key_file}  ${valid_key_name}
  # and input file in special field
  Choose File  ${locator.singup_upload_key_file_input}  ${key_file_path}

  # input pass
  Wait Until Element Is Enabled  ${locator.singup_pass_to_key}
  ${data.singup_pass}=  Get File  ${path_to_root_submodule}/payload_data/key_pass.txt
  #${data.singup_pass}=  Convert To String  ${raw_file_path}
  Input Text  ${locator.singup_pass_to_key}  ${data.singup_pass}

  Sleep  2  # add becouse some test drops here and wait don't help
  # press scan
  Wait And Click  ${locator.singup_button_to_read_data}

  # press go on
  Wait And Click  ${locator.singup_button_go_ahead}

  # exit from frame becouse button send outside this frame
  Unselect Frame

  # singup tender
  Sleep  3  # add becouse some test drops here and wait don't help
  Wait And Click  ${locator.singup_button_singup_tender}

SingUp Qulifiacation
  # click singup qulification
  Log To Console  [+] SingUp Qulification
  Focus  xpath=//div[@class="languages"]
  Wait And Click  xpath=//button[@ng-click="sign()"]
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  #SingUp Entity

SingUp Tender
  # click singup tender
  Log To Console  [+] SingUp Tender
  Wait And Click  ${locator.singup_tender_button_form}
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  #SingUp Entity

SingUp Contract
  # click singup tender
  Log To Console  [+] SingUp Contract
  Wait And Click  ${locator.singup_tender_button_form}
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  #SingUp Entity

SingUp Plan
  # click singup plan
  Log To Console  [+] SingUp Plan
  Wait And Click  ${locator.singup_plan_button_form}
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  #SingUp Entity

Check Lot Stash Is Open
  ${status_get_milestone_code}=  Run Keyword And Return Status  Get Text  ${locator.view_milestone[0].code}
  Run Keyword If  ${status_get_milestone_code} == False    Wait And Click  ${locator.view_lot_accordeon}

Go To Create OpenEU
  Go To  https://autotest.newtend.com/opc/provider/create-tender/multilot/aboveThresholdEU/plan/${data.plan_internal_id}

