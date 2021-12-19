** Settings ***
Library  String
Library  DateTime
Library  ../helper/newtend_service.py
Resource  ../helper/data.robot

*** Keywords ***

Create Plan
    [ARGUMENTS]  ${plan_user}  ${plan_data}  @{ARGUMENTS}

    ${plan_data}=  overwrite_procuringEntity_for_plan  ${plan_data}
    ${plan_for_tender_type}=   Get From Dictionary   ${plan_data.data.tender}   procurementMethodType

    ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget
    #${plan_additionalClas_block}=   Get From Dictionary     ${plan_data.data}   additionalClassifications
    ${plan_classification_block}=   Get From Dictionary     ${plan_data.data}   classification
    ${plan_buyers_block}=   Get From Dictionary     ${plan_data.data}    buyers
    ${plan_tender_block}=   Get From Dictionary     ${plan_data.data}    tender
    ${plan_procurement_type}=   Get From Dictionary     ${plan_tender_block}    procurementMethodType

    # === Navigate into Plan' creat part ===
    Go To Page Create Plan
    Edit Plan Title And Description  ${plan_data}
    Edit Project  ${plan_data}
    Edit Plan Type  ${plan_data}
    Edit Plan Date  ${plan_data}
    Run Keyword If  '${plan_for_tender_type}' != 'esco'  Edit Plan Budget  ${plan_data}
    Edit Plan Milestones  ${plan_data}
    Edit Plan Items  ${plan_data}
    # Change Decsription  ${plan_data}
    Publish Plan
    Get Plan ID and HashID
    SingUp Plan
    ${tender_uaid}=  Set Variable  ${data.plan_id}
    # return id plan
    [Return]  ${tender_uaid}

add_financer_press
    # Adding one more financer inside Planning creation
    ${add_financer}=     Get Webelement   xpath=//button[@ng-click="addBreakDownField()"]
    Focus     ${add_financer}
    Sleep     1
    Click Element     ${add_financer}
    Sleep     2

set_dk_dkpp
  [Arguments]   ${dk_dkpp_id}
  [Documentation]   plan owner role
  ...       ${dk_dkpp_id} == DK_Id
  #Log To Console    We send to search DK ID - ${dk_dkpp_id}
  Sleep     1
  Click Element   xpath=//*[@id="classifier-search-field"]
  Input Text      id=classifier-search-field  ${dk_dkpp_id}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${dk_dkpp_id}')]   20
  Sleep     2
  Click Element                      xpath=//input[@ng-change="chooseClassificator(item)"]
  Sleep     1
  Click Element                      id=select-classifier-btn
  Sleep   3

Go To Page Create Plan
  Go To   https://autotest.newtend.com/opc/provider/plans/create
  Wait Until Page Contains Element    id=plan-description     20
    
  
Edit Plan Title And Description
  [Arguments]   ${plan_data}
  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget
  # Plan description
  Focus  id=plan-description
  Input Text   id=plan-description    ${plan_budget_block.description}
  Input Text   id=plan-notes          ${plan_budget_block.id}

Edit Plan Type
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Plan Type
  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget
  ${plan_tender_block}=   Get From Dictionary     ${plan_data.data}    tender

  ${plan_procurement_type}=   Get From Dictionary     ${plan_tender_block}    procurementMethodType
  ${procedure_relations}=      Get Webelement     id=reason
  Select From List by Value    ${procedure_relations}    ${plan_procurement_type}
    
Edit Plan Date
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Plan Date
  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget
  ${plan_tender_block}=   Get From Dictionary     ${plan_data.data}    tender

  # Input Dates for Plannings
  ${plan_start_date_raw}=     Get From Dictionary     ${plan_budget_block.period}   startDate
  ${plan_end_date_raw}=       Get From Dictionary     ${plan_budget_block.period}   endDate
  ${plan_start_date}=         Get Substring     ${plan_start_date_raw}   0   10
  ${plan_end_date}=           Get Substring     ${plan_end_date_raw}   0   10
  ${start_date_field}=        Get Webelement   id=input-date-plan-budget-period-startDate
  Execute Javascript    window.document.getElementById('input-date-plan-budget-period-startDate').removeAttribute("readonly")
  #  Input Text  ${start_date_field}     ${plan_start_date}
  Input Text  ${start_date_field}     2021
  ${end_date_field}=        Get Webelement   id=input-date-plan-budget-period-endDate
  Execute Javascript    window.document.getElementById('input-date-plan-budget-period-endDate').removeAttribute("readonly")
  Input Text  ${end_date_field}     2021
  # Input Text  ${end_date_field}     ${plan_end_date}
  # Tender period field
  ${tender_period_startDate_raw}=     Get From Dictionary     ${plan_tender_block.tenderPeriod}   startDate
  ${tender_period_startDate}=         Get Substring   ${tender_period_startDate_raw}  0    10
  Execute Javascript    window.document.getElementById('input-date-plan-tender-tenderPeriod-startDate').removeAttribute("readonly")
  ${tender_period_startDate_field}=   Get Webelement  id=input-date-plan-tender-tenderPeriod-startDate
  Input Text    ${tender_period_startDate_field}    2021-02
  # Input Text    ${tender_period_startDate_field}    ${tender_period_startDate}

Edit Plan Budget
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Plan Budget
  
  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget

  # Fill the fields Budget_id, description and total budget
  # Getting values
  ${total_budget_amount}=       Get From Dictionary     ${plan_budget_block}   amount
  ${total_budget_amountNet}=    Get From Dictionary     ${plan_budget_block}   amountNet
  ${total_budget_currency}=     Get From Dictionary     ${plan_budget_block}   currency

  # Filling the fields
  ${total_budget_amount_string}=   convert_budget    ${total_budget_amount}
  
  Focus   xpath=//*[@id="budget"]
  Click Element   xpath=//*[@id="budget"]
  Input Text    id=budget   ${total_budget_amount_string}
  ${budget_currency_dropdown}=    Get Webelement  id=currency
  Select From List By Label   ${budget_currency_dropdown}     ${total_budget_currency}
  # Filling Plan-Id and name
  ${planId}=    Get From Dictionary     ${plan_budget_block.project}    id
  ${planName}=  Get From Dictionary     ${plan_budget_block.project}    name
  Input Text  id=project-id       ${planId}
  Input Text  id=project-name     ${planName}


Edit Plan Milestones
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Plan Milestones

  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget

  # ========== Budget description LOOP ==============
  # Getting Breakdowns
  ${breakdown_list}=   Get From Dictionary    ${plan_budget_block}    breakdown
  ${list_len}=         Get Length   ${plan_budget_block.breakdown}
  ${add_financer}=     Get Webelement   xpath=//button[@ng-click="addBreakDownField()"]

  : FOR   ${INDEX}  IN RANGE    ${list_len}
  \   ${br_description}=      Get From Dictionary     ${breakdown_list[${INDEX}]}   description
  \   ${br_financing_type}=   Get From Dictionary     ${breakdown_list[${INDEX}]}   title
  \   ${br_amountValue}=      Get from Dictionary     ${breakdown_list[${INDEX}]}   value
  \   ${br_amount}=           Get from Dictionary     ${br_amountValue}   amount
  \   ${br_amount_string}=    convert_budget          ${br_amount}
  \   ${br_currency}=         Get from Dictionary     ${br_amountValue}   currency
  \   #Log To Console    ${br_description}
  \   ${br_financingType_dropdown}=   Get Webelement      id=bd_item_title-${INDEX}
  \   Select From List By Value       ${br_financingType_dropdown}    ${br_financing_type}
  \   Input Text        id=bd_item_description-${INDEX}   ${br_description}
  \   Input Text        id=bd_item_value_amount-${INDEX}  ${br_amount_string}
  \   ${br_currency_dropdown}=    Get Webelement          id=bd_item_value_currency-${INDEX}
  \   Select From List By Label   ${br_currency_dropdown}    ${br_currency}
  \   capture page screenshot
  \   Run Keyword If    ${INDEX} < ${list_len} - 1        add_financer_press
  # ==========================


Edit Plan Items
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Plan Items

  ${plan_classification_block}=   Get From Dictionary     ${plan_data.data}   classification

  # ========= Filling the Classificators ===========================================================
  # DK (open etc)
  Focus           id=classifierCPV
  Click Element   id=classifierCPV
  Sleep   2
  ${classifierCPV_id}=    Get From Dictionary     ${plan_classification_block}    id
  set_dk_dkpp     ${classifierCPV_id}

  # Adding Items into Plan
  ${plan_items_block}=         Get From Dictionary   ${plan_data.data}   items
  ${items_len}=   Get Length  ${plan_items_block}
  :FOR   ${I}   IN RANGE  ${items_len}
  \   ${plan_item_description}=    Get From Dictionary   ${plan_items_block[${I}]}    description
  \   ${plan_item_quantity_raw}=   Get From Dictionary   ${plan_items_block[${I}]}    quantity
  \   ${plan_item_quantity_string}=  convert_quantity    ${plan_item_quantity_raw}
  \   ${plan_item_unit}=        Get From Dictionary      ${plan_items_block[${I}].unit}  name
  \   ${add_item_btn}=          Get Webelement  xpath=//button[@ng-click="addField()"]
  \   Focus    ${add_item_btn}
  \   Wait Until Page Contains Element  ${add_item_btn}
  \   Click Element    ${add_item_btn}
  \   Wait Until Element Is Enabled  id=itemDescription0
  \   Input Text  id=itemDescription0      ${plan_item_description}
  \
  \   # esco refactoring
  \   ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${plan_items_block[${I}]}  quantity
  \   ${locator_exist}=  Run Keyword And Return Status  Get WebElement  id=quantity0
  \   ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary    ${plan_items_block[${I}]}  quantity
  \   ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary    ${plan_items_block[${I}]}  quantity
  \   ${data_key}=  convert_quantity  ${data_key}
  \   Run Keyword If  ${key_exist} and ${locator_exist}  Input Text  id=quantity0  ${data_key}
  \
  \   ${locator_exist}=  Run Keyword And Return Status  Get WebElement  xpath=//select[@id="measurementUnits${I}"]
  \   Run Keyword If  ${locator_exist}  Edit Plan Item Measure List  ${plan_item_unit}
  \
  \   # Item classifiers
  \   ${item_dk_value}=   Get From Dictionary     ${plan_items_block[${I}].classification}   id
  \   Focus       id=classifier1${I}
  \   Click Element       id=classifier1${I}
  \   set_dk_dkpp         ${item_dk_value}
  \   Sleep   1
  # :todo UNCOMMENT WHEN ALL CLASSIFICATORS WILL WORK
  #    \   ${item_dkpp_value_list}=   Get From Dictionary     ${plan_items_block[${I}]}   additionalClassifications
  #    \   ${item_dkpp_value}=        Get From Dictionary     ${item_dkpp_value_list[0]}  id
  #    \   Focus   id=classifier2${I}
  #    \   Click Element   id=classifier2${I}
  #    \   set_dk_dkpp     ${item_dkpp_value}
  #    \   Sleep   1
  \   ${item_deliveryDate}=         Get From Dictionary     ${plan_items_block[${I}].deliveryDate}   endDate
  \   ${item_deliveryEndDate}=      Get Substring   ${item_deliveryDate}  0    10
  \   ${item_deliveryDate_field}=   Get Webelement  id=start-date-delivery${I}
  \   Execute Javascript    window.document.getElementById('start-date-delivery${I}').removeAttribute("readonly")
  \   Input Text    ${item_deliveryDate_field}    ${item_deliveryEndDate}

Publish Plan
  Log To Console  [+] Publish Plan
  Wait Until Element Is Enabled  id=submit-btn
  Focus  id=submit-btn
  Click Element     id=submit-btn
  Sleep   5
  Wait Until Page Contains Element    id=planID

Change Decsription
  [Arguments]   ${plan_data}
  Log To Console  [+] Change Decsription
  ${plan_budget_block}=   Get From Dictionary   ${plan_data.data}   budget
  # delete labal test from description
  Перейти до редагування плану  ${data.plan_id_hash}
  ${locator.plan_budget_description}=  Set Variable  xpath=//input[@id="plan-description"]
  Wait Until Page Contains Element  ${locator.plan_budget_description}
  # input new value
  Focus  ${locator.plan_budget_description}
  Input Text   ${locator.plan_budget_description}  ${plan_budget_block.description}

Edit Project
  [Arguments]   ${plan_data}
  Log To Console  [+] Edit Project

  ${plan_project_block}=   Get From Dictionary   ${plan_data.data.budget}  project

  ${data.plan_project_id}=     Get From Dictionary   ${plan_project_block}   id
  ${data.plan_project_name}=   Get From Dictionary   ${plan_project_block}   name

  Wait And Type  ${locator.edit_plan_project_id}  ${data.plan_project_id}
  Wait And Type  ${locator.edit_plan_project_name}  ${data.plan_project_name}

Edit Plan Item Measure List
  [Arguments]   ${plan_item_unit}
  Log To Console  [+] Edit Plan Item Measure List

  Sleep  3
  ${select_measure_list}=  Set Variable  xpath=//select[@ng-model="item.unit"]
  Select From List By Label  ${select_measure_list}  ${plan_item_unit}

Get Plan ID and HashID
  Log To Console  [+] Get Plan ID and HashID
  # set global var plan id hash for other tests
  # for get page plan in site
  ${plan_hash}=  Get Text  id=view-plan-id
  Set Global Variable  ${data.plan_id_hash}  ${plan_hash}
  # get id
  ${plan_uaid}=   Get Text  id=planID
  Set Global Variable  ${data.plan_id}  ${plan_uaid}
  
  Wait Until Page Contains Element    id=sign-tender-btn

Put Plan In Global
  [Arguments]  @{ARGS}  
  ${username}=  Set Variable  ${ARGS[0]}

  ${plan_hash}=  Get Text  id=view-plan-id
  ${plan_data}=  get_plan_data_from_cbd  ${plan_hash}
  Set Global Variable  ${USERS.users['${username}'].tender_data.data}  ${plan_data}
