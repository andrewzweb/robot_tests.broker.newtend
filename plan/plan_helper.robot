** Settings ***
#Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Keywords ***
Check and change input field
  [Arguments]   ${current_locator}  ${new_value}
  Wait Until Page Contains Element  ${current_locator}
  Focus  ${current_locator}
  Input Text  ${current_locator}  ${new_value}

Check and change date field
  [Arguments]   ${current_locator}  ${new_value}
  # lifehask now date is can cahnge
  Wait Until Element Is Enabled  ${current_locator}
  Focus  ${current_locator}
  ${field_date_id_name}=  Get Substring  ${current_locator}  19  -2
  Execute Javascript    window.document.getElementById('${field_date_id_name}').removeAttribute("readonly")
  Input text  ${current_locator}  ${new_value}

Опубліковати план
  [Tags]  helper
  #${locator.publish_plan}=    xpath=//button[@ng-click="publish(plan)"]
  Wait Until Page Contains Element    xpath=//button[@ng-click="publish(plan)"]
  Focus    xpath=//button[@ng-click="publish(plan)"]
  Click Element    xpath=//button[@ng-click="publish(plan)"]
  
Пошук плана
  [Tags]  helper
  [Arguments]  ${plan_id}
  
  # open search page with our plan_id
  Go To  https://dev23newtend.com/opc/provider/plans/all/?pageNum=1&query=${plan_id}&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=

  # select plan from list and click
  ${locator.plan_id_in_search}=  Get WebElement  xpath=//span[contains(text(), '${ARGUMENTS[1]}')]
  Wait Until Page Contains Element  ${locator.plan_id_in_search}
  Click Element  ${locator.plan_id_in_search}

Перейти до редагування плану
  [Tags]  helper
  [Arguments]  ${plan_id}
  
  # get edit PLAN page
  Go To  https://dev23newtend.com/opc/provider/plans/${plan_id}/edit
