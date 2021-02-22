*** Settings ***
#Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  newtend_service.py

*** Variables ***
${locator.login}            id=input_93
${locator.password}         id=input_94
${locator.login_btn}        id=open-enter-modal-btn
${locator.login_click}      xpath=//button[@ng-click="vm.loginUser()"]

${locator.title}                     id=tender-title
${locator.view_title}                id=view-tender-title
${locator.description}               id=tender-description
${locator.view_description}          id=view-tender-description
${locator.edit.description}          name=tenderDescription
${locator.value.amount}              id=budget
${locator.view_value_amount}         id=view-tender-value
${locator.minimalStep.amount}        xpath=//div[@ng-bind="tender.minimalStep.amount"]
${locator.tenderId}                  xpath=//a[@class="ng-binding ng-scope"]
${locator.procuringEntity.name}      xpath=//div[@ng-bind="tender.procuringEntity.name"]
${locator.enquiryPeriod.StartDate}   id=start-date-enquiry      # New name for tenders
${locator.enquiryPeriod.endDate}     id=end-date-enquiryPeriod  # New name for tenders
${locator.tenderPeriod.startDate}    id=start-date-enquiry      # New name for tenders
${locator.tenderPeriod.endDate}      id=end-date-tenderPeriod   # New name for tenders
${locator.items[0].deliveryAddress}                             id=deliveryAddress
${locator.items[0].deliveryDate.endDate}                        id=end-date-delivery
${locator.items[0].description}                                 xpath=//div[@ng-bind="item.description"]
${locator.items[0].classification.scheme}                       id=classifier
${locator.items[0].classification.scheme.title}                 xpath=//label[contains(., "Классификатор CPV")]
${locator.items[0].additional_classification[0].scheme}         id=classifier2
${locator.items[0].additional_classification[0].scheme.title}   xpath=//label[@for="classifier2"]
${locator.items[0].quantity}                                    id=quantity
${locator.items[0].unit.name}                                   xpath=//span[@class="unit ng-binding"]
${locator.edit_tender}     id=edit-tender-btn
#${locator.edit_tender}     xpath=//a[@ui-sref="tenderView.edit({id: tender.cdb_id})"]
#${locator.edit_tender}     xpath=//button[@ng-if="actions.can_edit_tender"]
${locator.edit.add_item}   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
${locator.save}            id=submit-btn
${locator.QUESTIONS[0].title}         xpath=//span[@class="user ng-binding"]
${locator.QUESTIONS[0].description}   xpath=//span[@class="question-description ng-binding"]
${locator.QUESTIONS[0].date}          xpath=//span[@class="date ng-binding"]

${locator.e_logo}       xpath=//a[@ui-sref="goHome"]

# negotiation locators
${locator.cause_descr}      id=tender-cause-description

# ==================
${locator.feature_main}     id=qualityIndicator
${locator.lot_main}         id=lot
${locator.lot_relation}     id=itemLot0
${locator.lot_title}        id=title0   # Need to use ${ARGUMENTS[x]} as lot identifier number
${locator.lot_description}  id=description0
${locator.lot_budget}       id=budget0
${locator.lot_step}         id=step0
${locator.lot_add}          id=add-lot-0
${locator.lot_save}         xpath=//button[@ng-click="save()"]

# Locators for reporting Participant add
${locator.supplier_company_name}    id=short-name
${locator.supplier_legal_name}      id=legalName
${locator.supplier_url}        id=uri
${locator.supplier_phone}      id=telephone
${locator.supplier_name}       id=name
${locator.supplier_email}      id=email
${locator.supplier_zip}        id=postalCode
${locator.supplier_region}     id=region
${locator.supplier_locality}   id=locality
${locator.supplier_streetAddress}   id=streetAddress
${locator.supplier_ua-id}      id=ua-id

# View locators
${locator.view_country}     xpath=//span[@ng-if="tender.procuringEntity.address.countryName"]
${locator.view_locality}    xpath=//span[@ng-if="tender.procuringEntity.address.locality"]
${locator.view_zip}         xpath=//span[@ng-if="tender.procuringEntity.address.postalCode"]
${locator.view_region}      xpath=//span[@ng-if="tender.procuringEntity.address.region"]
${locator.view_street}      xpath=//span[@ng-if="tender.procuringEntity.address.streetAddress"]
${locator.view.procuringEntity.name}    xpath=//div[@class="block-info__text block-info__text--big block-info__text--bold ng-binding"]

*** Keywords ***
Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=   update_data_for_newtend   ${tender_data}
  [Return]   ${tender_data}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  ${alias}=   Catenate   SEPARATOR=   role_    ${ARGUMENTS[0]}
  Set Global Variable   ${BROWSER_ALIAS}   ${alias}
  Open Browser
  ...      ${USERS.users['${ARGUMENTS[0]}'].homepage}
  ...      ${USERS.users['${ARGUMENTS[0]}'].browser}
  ...      alias=${BROWSER_ALIAS}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If       '${ARGUMENTS[0]}' != 'Newtend_Viewer'   Login    ${ARGUMENTS[0]}
  # Change Language to Ukr in the UI
  Click Element     xpath=//a[@ng-click="vm.setLanguage('uk')"]
  Sleep     3


Login
  [ARGUMENTS]   @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  Wait Until Page Contains Element   ${locator.login_btn}   20
  Click Element   ${locator.login_btn}
  Sleep     2
  Wait Until Page Contains Element  ${locator.login}    10
  Click Element   ${locator.login}
  Input text   ${locator.login}      ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text   ${locator.password}   ${USERS.users['${ARGUMENTS[0]}'].password}
  Sleep     2
  Click Element   ${locator.login_click}
  : FOR    ${INDEX}     IN RANGE    0   5
  \   Sleep     3
  \   ${logo}=      Get Matching Xpath Count    xpath=//a[@ui-sref="goHome"]
  \   Exit For Loop If  '${logo}' > '0'
  Log To Console    Success log as - '${ARGUMENTS[0]}'

  # =================== Planning =============
Створити план
    [ARGUMENTS]   @{ARGUMENTS}
    [Documentation]  Works for tender_owner role
    ...      ${ARGUMENTS[0]} ==  username
    ...      ${ARGUMENTS[1]} ==  tender_data_json
    # :TODO Parse JSON
    Log To Console    ${ARGUMENTS[1]}
    ${plan_budget_block}=   Get From Dictionary   ${ARGUMENTS[1].data}   budget
    ${plan_additionalClas_block}=   Get From Dictionary     ${ARGUMENTS[1].data}   additionalClassifications
    ${plan_classification_block}=   Get From Dictionary     ${ARGUMENTS[1].data}   classification
    ${plan_buyers_block}=   Get From Dictionary     ${ARGUMENTS[1].data}    buyers
    ${plan_tender_block}=   Get From Dictionary     ${ARGUMENTS[1].data}    tender
    ${plan_procurement_type}=   Get From Dictionary     ${plan_tender_block}    procurementMethodType

    Log To Console   ${plan_budget_block}
    # === Navigate into Plan' creat part ===
#    Click Element   id=create-menu
#    Sleep   1
#    Click Element   xpath=//a[@href="/opc/provider/plans/create"]
    Go To   https://dev23.newtend.com/opc/provider/plans/create
    Wait Until Page Contains Element    id=plan-description     5

    # ======== Filling the plan' fields ===============
    # Plan description
    Input Text   id=plan-description    ${plan_budget_block.description}
    Input Text   id=plan-notes          ${plan_budget_block.id}

    # Drop down operation
    ${procedure_relations}=      Get Webelement     id=reason
    Select From List by Value    ${procedure_relations}    ${plan_procurement_type}

    # Input Dates for Plannings
    ${plan_start_date_raw}=     Get From Dictionary     ${plan_budget_block.period}   startDate
    ${plan_end_date_raw}=       Get From Dictionary     ${plan_budget_block.period}   endDate
    ${plan_start_date}=         Get Substring     ${plan_start_date_raw}   0   10
    ${plan_end_date}=           Get Substring     ${plan_end_date_raw}   0   10
    ${start_date_field}=        Get Webelement   id=input-date-plan-budget-period-startDate
    Execute Javascript    window.document.getElementById('input-date-plan-budget-period-startDate').removeAttribute("readonly")
#    Input Text  ${start_date_field}     ${plan_start_date}
    Input Text  ${start_date_field}     2021
    ${end_date_field}=        Get Webelement   id=input-date-plan-budget-period-endDate
    Execute Javascript    window.document.getElementById('input-date-plan-budget-period-endDate').removeAttribute("readonly")
    Input Text  ${end_date_field}     2021
#    Input Text  ${end_date_field}     ${plan_end_date}
    # Tender period field
    ${tender_period_startDate_raw}=     Get From Dictionary     ${plan_tender_block.tenderPeriod}   startDate
    ${tender_period_startDate}=         Get Substring   ${tender_period_startDate_raw}  0    10
    Execute Javascript    window.document.getElementById('input-date-plan-tender-tenderPeriod-startDate').removeAttribute("readonly")
    ${tender_period_startDate_field}=   Get Webelement  id=input-date-plan-tender-tenderPeriod-startDate
    Input Text    ${tender_period_startDate_field}    2021-02
#    Input Text    ${tender_period_startDate_field}    ${tender_period_startDate}

    # Fill the fields Budget_id, description and total budget
    # Getting values
    ${total_budget_amount}=       Get From Dictionary     ${plan_budget_block}   amount
    ${total_budget_amountNet}=    Get From Dictionary     ${plan_budget_block}   amountNet
    ${total_budget_currency}=     Get From Dictionary     ${plan_budget_block}   currency
    # Converting Float into String
#    ${total_budget_amountNet_string}=   convert_budget    ${total_budget_amountNet}
    # Filling the fields
#    Input Text  id=budget   ${total_budget_amountNet_string}
    ${total_budget_amount_string}=   convert_budget    ${total_budget_amount}
    # Filling the fields
    Input Text  id=budget   ${total_budget_amount_string}
    ${budget_currency_dropdown}=    Get Webelement  id=currency
    Select From List By Label   ${budget_currency_dropdown}     ${total_budget_currency}
    # Filling Plan-Id and name
    ${planId}=    Get From Dictionary     ${plan_budget_block.project}    id
    ${planName}=  Get From Dictionary     ${plan_budget_block.project}    name
    Input Text  id=project-id       ${planId}
    Input Text  id=project-name     ${planName}

    # ========== Budget description LOOP ==============
    # Getting Breakdowns
    ${breakdown_list}=   Get From Dictionary    ${plan_budget_block}    breakdown
    ${list_len}=         Get Length   ${plan_budget_block.breakdown}
    Log To Console       NUMBER OF BREAKDOWNS- ${list_len}
    ${add_financer}=     Get Webelement   xpath=//button[@ng-click="addBreakDownField()"]

    : FOR   ${INDEX}  IN RANGE    ${list_len}
    \   ${br_description}=      Get From Dictionary     ${breakdown_list[${INDEX}]}   description
    \   ${br_financing_type}=   Get From Dictionary     ${breakdown_list[${INDEX}]}   title
    \   ${br_amountValue}=      Get from Dictionary     ${breakdown_list[${INDEX}]}   value
    \   ${br_amount}=           Get from Dictionary     ${br_amountValue}   amount
    \   ${br_amount_string}=    convert_budget          ${br_amount}
    \   ${br_currency}=         Get from Dictionary     ${br_amountValue}   currency
    \   Log To Console    ${br_description}
    \   ${br_financingType_dropdown}=   Get Webelement      id=bd_item_title-${INDEX}
    \   Select From List By Value       ${br_financingType_dropdown}    ${br_financing_type}
    \   Input Text        id=bd_item_description-${INDEX}   ${br_description}
    \   Input Text        id=bd_item_value_amount-${INDEX}  ${br_amount_string}
    \   ${br_currency_dropdown}=    Get Webelement          id=bd_item_value_currency-${INDEX}
    \   Select From List By Label   ${br_currency_dropdown}    ${br_currency}
    \   capture page screenshot
    \   Run Keyword If    ${INDEX} < ${list_len} - 1        add_financer_press
  # ==========================

  # ========= Filling the Classificators ===========================================================
  # DK (open etc)
    Focus           id=classifierCPV
    Click Element   id=classifierCPV
    Sleep   2
    ${classifierCPV_id}=    Get From Dictionary     ${plan_classification_block}    id
    set_dk_dkpp     ${classifierCPV_id}

    # :TODO UNCOMMENT WHEN ALL CLASSIFICATORS WILL WORK
    # DKPP (open etc)
#    Click Element   id=classifierDKPP
#    Sleep   2
#    ${list_additionaClass}=     Get Length  ${plan_additionalClas_block}
#    Sleep   2
#    :FOR    ${I}   IN RANGE   ${list_additionaClass}
#    \   ${additional_classifierId}=     Get From Dictionary   ${plan_additionalClas_block[${I}]}  id
#    \   set_dk_dkpp     ${additional_classifierId}

    # Adding Items into Plan
    ${plan_items_block}=         Get From Dictionary   ${ARGUMENTS[1].data}   items
    ${items_len}=   Get Length  ${plan_items_block}
    :FOR   ${I}   IN RANGE  ${items_len}
    \   ${plan_item_description}=    Get From Dictionary   ${plan_items_block[${I}]}    description
    \   ${plan_item_quantity_raw}=   Get From Dictionary   ${plan_items_block[${I}]}    quantity
    \   ${plan_item_quantity_string}=   convert_budget     ${plan_item_quantity_raw}
    \   ${plan_item_unit}=        Get From Dictionary      ${plan_items_block[${I}].unit}  name
#    \   ${plan_itemUnit_normal}=    key_by_value  ${plan_item_unit}
    \   ${add_item_btn}=          Get Webelement  xpath=//button[@ng-click="addField()"]
    \   Focus    ${add_item_btn}
    \   Click Element    ${add_item_btn}
    \   Sleep    1
    \   Input Text  id=itemDescription0      ${plan_item_description}
    \   Input Text  id=quantity0             ${plan_item_quantity_string}
    \   ${measure_list}=    Get Webelement   id=measure-list
    \   Click Element       ${measure_list}
    \   ${measure_name}=    Get Webelements   xpath=//a[@id="measure-list"]/..//a[contains(text(), '${plan_item_unit}')]
    \   Click Element       ${measure_name[-1]}
    \   Sleep     1
    # Item classifiers
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

    Click Element     id=submit-btn

    Wait Until Page Contains Element    id=planID   10

    ${tender_uaid}=   Get Text  id=planID
    [Return]  ${tender_uaid}

  # ========= Click on the "Publish" button ========================================================
    #${publish_plan}=     Get Webelement   xpath=//button[@ng-click="publish(plan)"]
    #Focus     ${publish_plan}
    #Sleep     1
    #Click Element     ${publish_plan}
    #Sleep     2
#====================================== End of Створити план =========================================

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
  Log To Console    We send to search DK ID - ${dk_dkpp_id}
  Sleep     1
  Click Element   xpath=//*[@id="classifier-search-field"]
  Input Text      id=classifier-search-field  ${dk_dkpp_id}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${dk_dkpp_id}')]   20
  Sleep     2
  Click Element                      xpath=//input[@ng-change="chooseClassificator(item)"]
  Sleep     1
  Click Element                      id=select-classifier-btn
  Sleep   3


Оновити сторінку з планом
  [Arguments]   ${username}    ${tender_uaid}
  Reload Page

Пошук плану по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Go To     https://dev23.newtend.com/opc/provider/plans/all/?pageNum=1&query=&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=
#  Click Element     id="main-menu"
#  Click Element     id="all-plans-menu"
#  Mouse Over        id="all-plans-menu"
#  Click Element     id="menu_container_1"
#  Wait Until Page Contains Element    id="input_13"  <--- This element has dynamic ID
  Wait Until Page Contains Element    xpath=//input[@ng-model="searchData.query"]   10
  ${search_field}=  Get Webelement    xpath=//input[@ng-model="searchData.query"]
  Click Element     ${search_field}
  Input Text        ${search_field}   ${tender_uaid}
  Click Element     xpath=//button[@ng-click="search()"]
  Wait Until Page Contains Element    xpath=//a[@class="row tender-info ng-scope"]    10
  ${plan_raw}=  Get Webelement   xpath=//a[@class="row tender-info ng-scope"]/..//span[contains(text(), '${tender_uaid}')]
  Click Element     ${plan_raw}


Отримати інформацію із плану
  [Arguments]   @{ARGUMENTS}
  [Documentation]   Roles: seems for all roles
  ...       ${ARGUMENTS[0]} == user_role
  ...       ${ARGUMENTS[1]} == plan_uaid
  ...       ${ARGUMENTS[1]} == field_name
  Log To Console    Arg0 - ${ARGUMENTS[0]}
  Log To Console    Arg1 - ${ARGUMENTS[1]}
  Log To Console    Arg2 - ${ARGUMENTS[2]}
  Run Keyword And Return  Отримати Планову інформацію про ${ARGUMENTS[2]}

Отримати Планову інформацію про status
  ${plan_status_raw}=   Get Text   xpath=//span[@class="status ng-binding"]
  ${plan_status}=   convert_to_newtend_normal   ${plan_status_raw}
  [Return]     ${plan_status}


Внести зміни в план
  [Arguments]   @{ARGUMENTS}
  [Documentation]   For tender_owner role
  ...       ${ARGUMENTS[0]} ==  user_role
  ...       ${ARGUMENTS[1]} ==  plan_uaid
  ...       ${ARGUMENTS[2]} ==  field_name
  ...       ${ARGUMENTS[3]} ==  field_value
  Log To Console   Arg0 - ${ARGUMENTS[0]}
  Log To Console   Arg1 - ${ARGUMENTS[1]}
  Log To Console   Arg2 - ${ARGUMENTS[2]}
  Log To Console   Arg3 - ${ARGUMENTS[3]}
  # Searching for necessary Plan
  Go To     https://dev23.newtend.com/opc/provider/plans/all/?pageNum=1&query=${ARGUMENTS[1]}&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=
  Wait Until Page Contains Element    xpath=//a[@class="row tender-info ng-scope"]    10
  ${plan_raw}=  Get Webelement   xpath=//a[@class="row tender-info ng-scope"]/..//span[contains(text(), '${ARGUMENTS[1]}')]
  Click Element     ${plan_raw}
  Sleep     1
  Run Key Word And Return   Змінити в плані поле ${ARGUMENTS[2]} і зберегти     ${ARGUMENTS[3]}

Змінити в плані поле budget.description і зберегти
  [Arguments]   ${field_description}
  Log To Console    We are working on this process!

Змінити в плані поле budget.amount і зберегти
  [Arguments]   ${field_description}
  Log To Console    We are working on this process!



Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Works for tender_owner role
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
## Initialisation, Getting values from Dictionary -== Main Block ==-
  ${procurementMethodType}=   Get From Dictionary    ${ARGUMENTS[1].data}    procurementMethodType
  Log To Console    -== ProcurementMethod - ${procurementMethodType} ==-
  ${budget}=        Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Get From Dictionary   ${ARGUMENTS[1].data.value}   amount

## Getting some Data according to procedure's type -== Main Block 1 ==-
  # Minimal step for all procedures except two
  ${step_rate}=   Run Keyword If  '${procurementMethodType}' != 'reporting' and '${procurementMethodType}' != 'negotiation'  Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount

  # Negotiation reson for Negotiation procedures only
  ${cause}=        Run Keyword If  '${procurementMethodType}' == 'negotiation'   Get From Dictionary   ${ARGUMENTS[1].data}   cause
  ${cause_descr}=  Run Keyword If  '${procurementMethodType}' == 'negotiation'   Get From Dictionary   ${ARGUMENTS[1].data}   causeDescription

  # :TODO Create separate words for getting data for Item and Lot according to procedure.
#  ${start_date}=           Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}    startDate
  ${end_date}=     Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}    endDate
#  ${enquiry_start_date}=   Get From Dictionary   ${ARGUMENTS[1].data.enquiryPeriod}   startDate
#  ${enquiry_end_date}=     Get From Dictionary   ${ARGUMENTS[1].data.enquiryPeriod}   endDate

    # :TODO 'Create tender' block need to be refactored in future
#  Sleep     3
#  Click Element     xpath=//a[@ng-click="vm.setLanguage('uk')"]
#  Sleep     5
#  Click Element     id=create-menu
#  Sleep     1
#  Click Element     xpath=//a[@ng-click="vm.createTender($event)"]
#  Sleep     2
#  Click Element     xpath=//md-select[@ng-model="vm.tenderProcedure"]
#  Sleep     2

# Selecting procedure according to needs
#  ${procedures_dropdown}=   Get Webelement  xpath=//select[@name="tenderProcedure"]

  Run Keyword If   '${procurementMethodType}' == 'reporting'          Click Element   xpath=//md-option[@value="reporting"]
  Run Keyword If   '${procurementMethodType}' == 'negotiation'        Click Element   xpath=//md-option[@value="negotiation"]
  Run Keyword If   '${procurementMethodType}' == 'negotiation'        Sleep   2
  Run Keyword If   '${procurementMethodType}' == 'negotiation'        Click Element   xpath=//md-radio-button[@value="singlelot"]
  Run Keyword If   '${procurementMethodType}' == 'aboveThresholdUA'   Click Element   xpath=//md-option[@value="aboveThresholdUA"]
  Run Keyword If   '${procurementMethodType}' == 'aboveThresholdEU'   Click Element   xpath=//md-option[@value="aboveThresholdEU"]
  Sleep     2

# Confirming procedure selection
  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Click Element     xpath=//button[@ng-click="vm.createTender(vm.tenderProcedure, vm.tenderLots)"]
  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Sleep     7

  # Direct navigating to Lotless belowUA creation' page
  Run Keyword If   '${procurementMethodType}' == 'belowThreshold'     Go To     https://dev23.newtend.com/opc/provider/create-tender/singlelot/belowThreshold/tender/
  Wait Until Page Contains Element  id=tender-title     5

  # Getting Data to fill inside the tender
  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description

  ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}               items



# Input fields tender
  Input text   ${locator.title}              ${title}
  Input text   ${locator.edit.description}   ${description}
  ${new_budget}=    Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']    convert_budget    ${budget}
  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Input text    ${locator.value.amount}    ${new_budget}
  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Click Element     id=with-nds

  # Negotiation Main Block fill
  Run Keyword If   '${procurementMethodType}' == 'negotiation'   Input text   ${locator.cause_descr}    ${cause_descr}
  Run Keyword If   '${procurementMethodType}' == 'negotiation'   Click Element    xpath=//select[@id="reason"]
  Sleep     1
  Run Keyword If   '${procurementMethodType}' == 'negotiation'   Click Element    xpath=//option[@value="string:${cause}"]
  Sleep     1

# Getting data for lots, items and features
# :TODO expand list of procedures according to needs - defense, competitiveDialog, etc.
  Run Keyword If    '${procurementMethodType}' in ['aboveThresholdUA', 'aboveThresholdEU']    Add lots     ${ARGUMENTS[1]}

# Add Item(s)
  Додати предмет   ${ARGUMENTS[1]}

  Run Keyword If   '${procurementMethodType}' in ['belowThreshold']   Click Element     id=with-nds
  # Filling the Main Procurement category
  ${procurementCategory}=           Run Keyword If   '${procurementMethodType}' in ['belowThreshold']   Get From Dictionary   ${ARGUMENTS[1].data}   mainProcurementCategory
  ${procurementCategory_field}=     Run Keyword If   '${procurementMethodType}' in ['belowThreshold']   Get Webelement        id=mainProcurementCategory
  # ${procurementCategory_click}=     Run Keyword If   '${procurementMethodType}' in ['belowThreshold']   Click Element         ${procurementCategory_field}
  Run Keyword If   '${procurementMethodType}' in ['belowThreshold']   Select From List By Value   ${procurementCategory_field}   ${procurementCategory}

#  Run Keyword If    '${TENDER_MEAT}' != 'False'    Add meats to tender   ${ARGUMENTS[1]}
#  Run Keyword If    '${LOT_MEAT}' != 'False'       Add meats to lot      ${ARGUMENTS[1]}
#  Run Keyword If    '${ITEM_MEAT}' != 'False'      Add meats to item     ${ARGUMENTS[1]}

# Set tender datatimes
  ${tenderingEnd_date_date}=  Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Get Substring   ${end_date}   0   10
  ${tenderingEnd_hours}=      Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Get Substring   ${end_date}   11   13
  ${tenderingEnd_minutes}=    Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Get Substring   ${end_date}   14   16

# Removing READONLY attribute from datepicker field
  Run Keyword If   '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']   Execute Javascript    window.document.getElementById('input-date-tender-enquiryPeriod-endDate').removeAttribute("readonly")
  Run Keyword If   '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']   Input Text    xpath=//input[@id="input-date-tender-enquiryPeriod-endDate"]     ${tenderingEnd_date_date}
  ${tenderingEnd_date_hours}=    Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']   Get Webelements   xpath=//table[@ng-model="tender.tenderPeriod.endDate"]/.//input[@ng-change="updateHours()"]
  Run Keyword If   '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']   Input Text    ${tenderingEnd_date_hours[-1]}       ${tenderingEnd_hours}
  ${tenderingEnd_date_minutes}=  Run Keyword If    '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']  Get Webelements   xpath=//table[@ng-model="tender.tenderPeriod.endDate"]/.//input[@ng-change="updateMinutes()"]
  Run Keyword If   '${procurementMethodType}' in ['belowThreshold', 'defense', 'aboveThresholdEU', 'aboveThresholdUA']   Input Text    ${tenderingEnd_date_minutes[-1]}     ${tenderingEnd_minutes}
  Sleep     2

# Save
  Sleep     2
  Click Element          ${locator.save}
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//div[@class="modal-body ng-binding"]
  \   Exit For Loop If   '${count}' == '1'
  Click Element                      id=no-docs-btn
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//div[@class="modal-body ng-binding"]
  \   Exit For Loop If   '${count}' == '0'
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]/..//a[@class="ng-binding ng-scope"]   30
  ${tender_UAid}=         Get Text   xpath=//div[@class="title"]/..//a[@class="ng-binding ng-scope"]
  ${Ids}=        Convert To String   ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [Return]  ${Ids}

# Adding Lots into tenders
Add lots
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  lots_name
  ${procurementMethodType}=   Get From Dictionary    ${ARGUMENTS[0].data}    procurementMethodType
  Click Element     xpath=//input[@ui-sref="createTender.lot"]
  Sleep     2
  : FOR   ${INDEX}  IN RANGE   ${NUMBER_OF_LOTS}
  \   ${lots}=                  Get From Dictionary      ${ARGUMENTS[0].data}            lots
  \   ${lots_description}=      Get From Dictionary      ${lots[${INDEX}]}               description
  \   ${lots_description_en}=   Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU']   Get From Dictionary    ${lots[${INDEX}]}    description_en
  \   ${lots_title}=            Get From Dictionary      ${lots[${INDEX}]}               title
  \   ${lots_title_en}=         Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU']   Get From Dictionary    ${lots[${INDEX}]}    title_en
  \   ${lots_value}=            Get From Dictionary      ${lots[${INDEX}].value}         amount
  \   ${new_lots_value}=        convert_budget           ${lots_value}
  \   ${lots_step}=             Get From Dictionary      ${lots[${INDEX}].minimalStep}   amount
  \   ${new_lots_step}=         convert_budget           ${lots_step}
# Input Data into Lots fields
  \   Input Text    id=title${INDEX}        ${lots_title}
  \   Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU']    Input Text    id=title_en${INDEX}     ${lots_title_en}
  \   Input Text    id=description${INDEX}  ${lots_description}
  \   Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU']    Input Text    id=description_en${INDEX}     ${lots_description_en}
  \   Input Text    id=budget${INDEX}       ${new_lots_value}
  \   Input Text    id=step${INDEX}         ${new_lots_step}
  \   Run Keyword If    ${INDEX} < ${NUMBER_OF_LOTS} - 1   add_cross_press
  Click Element     xpath=//button[@ng-click="save()"]
  Sleep     2

# :TODO MEATS add
Add meats to tender
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  meat_name
  ${procurementMethodType}=   Get From Dictionary    ${ARGUMENTS[0].data}    procurementMethodType
  Run Keyword If   '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']    Focus  id=tender-people-amount
  Sleep     2
  Click Element     id=qualityIndicator
  Sleep     2
  : FOR   ${INDEX}  IN RANGE   ${TENDER_MEAT}
#  : FOR   ${INDEX}  IN RANGE   ${LOT_MEAT}
#  : FOR   ${INDEX}  IN RANGE   ${ITEM_MEAT}
  \   ${features_list}=    Get From Dictionary  ${ARGUMENTS[0].data}          features
  \   ${f_descr}=       Get From Dictionary     ${features_list[${INDEX}]}    description
  \   ${f_title}=       Get From Dictionary     ${features_list[${INDEX}]}    title
  \   ${f_descr_en}=    Run Keyword If  '${procurementMethodType}' in ['defense', 'aboveThresholdEU']   Get From Dictionary     ${features_list[${INDEX}]}    description_en
  \   ${f_title_en}=    Run Keyword If  '${procurementMethodType}' in ['defense', 'aboveThresholdEU']   Get From Dictionary     ${features_list[${INDEX}]}    title_en
  \   ${f_relation}=    Get From Dictionary     ${features_list[${INDEX}]}    featureOf
  \   ${f_enum}=        Get From Dictionary     ${features_list[${INDEX}]}    enum
  \   : FOR   ${n}   IN RANGE   3
  # :TODO this construction does not work
  \   \   ${enum_title}=    Get From Dictionary     ${f_enum[${n}]}     title
  \   \   ${enum_value}=    Get From Dictionary     ${f_enum[${n}]}     value

Add meats to lot
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  meat_name
  Log to console    Lots Meats

Add meats to item
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  meat_name
  Log to console    Items Meats

#Set Multi Ids
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
#  ${current_location}=      Get Location
#  ${id}=    Get Substring   ${current_location}   -41   -9
#  ${Ids}=   Create List     ${tender_UAid}   ${id}
Feature Dict
# :TODO Investigate features relation mechanismus!!!!
  [Arguments]  @{ARGUMENTS}
  : FOR   ${I}  IN RANGE    ${TENDER_MEAT}
  \   ${lots}=          Get From Dictionary      ${ARGUMENTS[0].data}        lots
  \   ${lots_title}=    Get From Dictionary      ${lots[${I}]}               title
  \   ${lots_id}=       Get From Dictionary      ${lots[${I}]}               id
  \   &{lots_dict}=     Create Dictionary   ${lots_id}=${lots_title}
  \   Log To Console    -== Dict - ${lots_dict} ==-
  [Return]   ${lots_dict}

Lot Dict
  [Arguments]  @{ARGUMENTS}
  : FOR   ${I}  IN RANGE    ${NUMBER_OF_LOTS}
  \   ${lots}=          Get From Dictionary      ${ARGUMENTS[0].data}        lots
  \   ${lots_title}=    Get From Dictionary      ${lots[${I}]}               title
  \   ${lots_id}=       Get From Dictionary      ${lots[${I}]}               id
  \   &{lots_dict}=     Create Dictionary   ${lots_id}=${lots_title}
  \   Log To Console    -== Dict - ${lots_dict} ==-
  [Return]   ${lots_dict}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items_name
  ${procurementMethodType}=   Get From Dictionary    ${ARGUMENTS[0].data}    procurementMethodType
# Lots dictionary dependency create id - as strange hash and description - relates to description
  ${lots_dict}=   Run Keyword If  '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']   Lot Dict   ${ARGUMENTS[0]}
#  Items block info
# === Loop Try to select items info === ${ARGUMENTS[1].data}               items
  : FOR   ${INDEX}  IN RANGE   ${NUMBER_OF_ITEMS}
  \   ${items}=                             Get From Dictionary       ${ARGUMENTS[0].data}   items
  \   ${item_description}=                  Get From Dictionary       ${items[${INDEX}]}     description

# Getting out item's relation to LOT
  \   ${related_lot}=   Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']   Get From Dictionary   ${items[${INDEX}]}   relatedLot
  \   Log To Console    related lot - ${related_lot}
  \   ${lots_descr}=    Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']   Get From Dictionary   ${lots_dict}   ${related_lot}
  \   Log To Console    -=== lots descr - ${lots_descr} ===-

# Filling all the other Item's fields
  \   Log to Console    item-0-description '${INDEX}' - '${item_description}'
  \   ${item_quantity_raw}=                 Get From Dictionary       ${items[${INDEX}]}     quantity
  \   ${item_quantity}=                     convert_quantity          ${item_quantity_raw}
  \   ${unit}=                              Get From Dictionary       ${items[${INDEX}]}     unit
  \   ${unit_code}=                         Get From Dictionary       ${unit}        code
  \   Log to console      unit code - ${unit_code}
  \   ${unit_name}=                         Get From Dictionary       ${unit}        name
  \   ${classification}=                    Get From Dictionary       ${items[${INDEX}]}                   classification
  \   ${classification_scheme}=             Get From Dictionary       ${items[${INDEX}].classification}    scheme
  \   ${classification_description}=        Get From Dictionary       ${items[${INDEX}].classification}    description
  \   ${classification_id}=                 Get From Dictionary       ${items[${INDEX}].classification}    id
  \   ${add_classification}=      Run Keyword If   '${classification_id}' == '99999999-9'  Get From Dictionary   ${items[${INDEX}]}   additionalClassifications
  \   ${add_classification_id}=   Run Keyword If   '${classification_id}' == '99999999-9'  Get From Dictionary   ${items[${INDEX}].add_classification}   id
  \   ${deliveryaddress}=                   Get From Dictionary       ${items[${INDEX}]}                   deliveryAddress
  \   ${deliveryaddress_postalcode}=        Get From Dictionary       ${items[${INDEX}].deliveryAddress}   postalCode
  \   ${deliveryaddress_countryname}=       Get From Dictionary       ${items[${INDEX}].deliveryAddress}   countryName
  \   ${deliveryaddress_streetaddress}=     Get From Dictionary       ${items[${INDEX}].deliveryAddress}   streetAddress
  \   ${deliveryaddress_region}=            Get From Dictionary       ${items[${INDEX}].deliveryAddress}   region
  \   ${deliveryaddress_locality}=          Get From Dictionary       ${items[${INDEX}].deliveryAddress}   locality
  \   ${deliverydate_start_date}=           Get From Dictionary       ${items[${INDEX}].deliveryDate}      startDate
  \   ${deliverydate_end_date}=             Get From Dictionary       ${items[${INDEX}].deliveryDate}      endDate
##  === Seems to be working -^- Loop for getting the values from Dictionary ===
  # Add item main info
  \   ${measure_list}=      Get Webelements     id=measure-list
  \   Click Element         ${measure_list[-1]}
  \   ${measure_name}=      Get Webelements   xpath=//a[@id="measure-list"]/..//a[contains(text(), '${unit_name}')]
  \   Click Element         ${measure_name[-1]}
  \   Sleep     1
  # Short time walk around.
  \   Input Text    xpath=//input[@ng-model="vm.item.description"]     ${item_description}
  \   Input text    xpath=//input[@ng-model="vm.item.quantity"]        ${item_quantity}
  #   :TODO Fix the QUANTITY field locator and then - uncomment below' string
#  \   Input text   id=quantity${INDEX}          ${item_quantity}
#  \   Input text   id=itemDescription${INDEX}   ${item_description}

# Set CPV
  \   Wait Until Page Contains Element   xpath=//input[contains(@id,'classifier-cpv-')]   5
  \   Click Element                      xpath=//input[contains(@id,'classifier-cpv-')]
#  \   Click Element                      id=classifier-1-${INDEX}

#  \   Wait Until Page Contains Element   id=classifier-1-${INDEX}
#  \   Click Element                      id=classifier-1-${INDEX}
  \   Wait Until Page Contains Element   id=classifier-search-field   100
  \   Input text                         id=classifier-search-field   ${classification_id}
  \   Wait Until Page Contains Element   xpath=//span[contains(text(),'${classification_id}')]   20
  \   Sleep     2
  \   Click Element                      xpath=//input[@ng-change="chooseClassificator(item)"]
  \   Sleep     1
  \   Click Element                      id=select-classifier-btn
# Set DKPP
  \   Run Keyword If   '${classification_id}' == '99999999-9'    Set DKPP      ${add_classification_id}
# Set Delivery Address
  \   Fill The Delivery Fields  ${deliveryaddress_countryname}  ${deliveryaddress_postalcode}  ${deliveryaddress_region}   ${deliveryaddress_locality}   ${deliveryaddress_streetaddress}
#  \   Focus                 xpath=//input[contains(@id, 'deliveryAddress-')]
#  \   Click Element         xpath=//input[contains(@id, 'deliveryAddress-')]
#  \   Wait Until Page Contains Element      xpath=//md-radio-button[@aria-label="Відповідно до документації"]   4
#  \   Click Element                         xpath=//md-radio-button[@aria-label="Відповідно до документації"]
#  \   Click Element                      id=deliveryAddress${INDEX}
#  \   Wait Until Page Contains Element   xpath=//input[@name="postal-code"]   20
#  \   Sleep     2
#  \   Input Text                         xpath=//input[@name="country_name"]      ${deliveryaddress_countryname}
#  \   Input Text                         xpath=//input[@name="postal-code"]       ${deliveryaddress_postalcode}
#  \   Input Text                         xpath=//input[@name="delivery-region"]   ${deliveryaddress_region}
#  \   Input Text                         xpath=//input[@name="company-city"]      ${deliveryaddress_locality}
#  \   Input Text                         xpath=//input[@name="street_address"]    ${deliveryaddress_streetaddress}
#  \   Sleep     2
#  \   Click Element                      xpath=//button[@ng-click="vm.save()"]
#  \   Sleep     4
# Selecting Item's relation to LOT From Drop Down
  \   ${lot_relations}=   Run Keyword If    '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']   Get Webelements     xpath=//select[@ng-model="item.relatedLot"]
  \   Sleep     2
  \   Run Keyword If  '${procurementMethodType}' in ['defense', 'aboveThresholdEU', 'aboveThresholdUA']  Select From List by Label    ${lot_relations[-1]}    ${lots_descr}

# :TODO Uncomment when IDs will be fixed
#Delivery Start date block
#  \   ${start_date_date}=  Get Substring   ${deliverydate_start_date}   0    10
#  \   ${hours}=            Get Substring   ${deliverydate_start_date}   11   13
#  \   ${minutes}=          Get Substring   ${deliverydate_start_date}   14   16
## Removing READONLY attribute from datepicker field
#  \   Execute Javascript    window.document.getElementById('start-date-delivery${INDEX}').removeAttribute("readonly")
#  \   Input Text    xpath=//input[@id="start-date-delivery${INDEX}"]     ${start_date_date}
#  \   ${start_date_hours}=      Get Webelements   xpath=//table[@ng-model="item.deliveryDate.startDate"]/.//input[@ng-change="updateHours()"]
#  \   Input Text    ${start_date_hours[-1]}       ${hours}
#  \   ${start_date_minutes}=    Get Webelements   xpath=//table[@ng-model="item.deliveryDate.startDate"]/.//input[@ng-change="updateMinutes()"]
#  \   Input Text    ${start_date_minutes[-1]}     ${minutes}
#  \   Sleep     2

# Delivery End date block
  \   ${end_date_date}=     Get Substring   ${deliverydate_end_date}   0    10
  \   ${end_hours}=         Get Substring   ${deliverydate_end_date}   11   13
  \   ${end_minutes}=       Get Substring   ${deliverydate_end_date}   14   16
  \   Log To Console    date - ${end_date_date}, hour - ${end_hours}, minutes - ${end_minutes}
# Removing READONLY attribute from datepicker field
# :TODO Uncomment below fields after IDs will be corrected
#  \   Execute Javascript    window.document.getElementById('end-date-delivery${INDEX}').removeAttribute("readonly")
#  \   Input Text    xpath=//input[@id="end-date-delivery${INDEX}"]     ${end_date_date}
#  \   ${end_date_hours}=      Get Webelements   xpath=//table[@ng-model="item.deliveryDate.endDate"]/.//input[@ng-change="updateHours()"]
#  \   Input Text    ${end_date_hours[-1]}       ${end_hours}
#  \   ${end_date_minutes}=    Get Webelements   xpath=//table[@ng-model="item.deliveryDate.endDate"]/.//input[@ng-change="updateMinutes()"]
#  \   Input Text    ${end_date_minutes[-1]}     ${end_minutes}
#  \   Sleep     2

  # Add new item
  \   Run Keyword If    ${INDEX} < ${NUMBER_OF_ITEMS} - 1   add_cross_press
  \   Sleep     2

add_cross_press
  ${cross}=    Get Webelements    xpath=//button[@ng-click="vm.addItem()"]
  Focus     ${cross[-1]}
  Sleep     1
  Click Element     ${cross[-1]}
  Sleep     2

Set DKPP
# :TODO Need to see for this behavior
  [Arguments]   ${add_classification_id}
  \   Sleep     3
  \   Click Element                      id=classifier-2-${INDEX}
  \   Wait Until Page Contains Element   id=classifier-search-field    100
  \   Input Text                         id=classifier-search-field    ${add_classification_id}
  \   Wait Until Page Contains Element   xpath=//span[contains(text(),'${add_classification_id}')]   20
  \   Sleep     2
  \   Click Element                      xpath=//input[@ng-change="chooseClassificator(item)"]
  \   Sleep     1
  \   Click Element                      id=select-classifier-btn
  \   Sleep     2

# Filling the Delivery info Pop-up
Fill The Delivery Fields
  [Arguments]   ${deliveryaddress_countryname}  ${deliveryaddress_postalcode}  ${deliveryaddress_region}   ${deliveryaddress_locality}   ${deliveryaddress_streetaddress}
  Focus                 xpath=//input[contains(@id, 'deliveryAddress-')]
  Click Element         xpath=//input[contains(@id, 'deliveryAddress-')]
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//md-radio-button[@aria-label="Відповідно до документації"]
  \   Exit For Loop If   '${count}' > '0'
  # :TODO Fix the IDs in UI and change them here, and uncomment necessary
#  Click Element                      id=deliveryAddress${INDEX}
#  Wait Until Page Contains Element   xpath=//input[@name="postal-code"]   20
#  Sleep     2
#  Input Text                         xpath=//input[@name="country_name"]      ${deliveryaddress_countryname}
#  Input Text                         xpath=//input[@name="postal-code"]       ${deliveryaddress_postalcode}
#  Input Text                         xpath=//input[@name="delivery-region"]   ${deliveryaddress_region}
#  Input Text                         xpath=//input[@name="company-city"]      ${deliveryaddress_locality}
#  Input Text                         xpath=//input[@name="street_address"]    ${deliveryaddress_streetaddress}
#  Sleep     2

  Click Element        xpath=//md-radio-button[@aria-label="Відповідно до документації"]

  Click Element        xpath=//button[@ng-click="vm.save()"]
  Sleep     4



Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]   Uploading document for repoting
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  file_path
  ...      ${ARGUMENTS[2]} ==  tender_uaid
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Wait Until Page Contains Element      xpath=//button[@ng-click="uploadDocument()"]    10
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  # Waiting for docs type selection modal
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//form[@name="uploadDocumentsForm"]
  \   Exit For Loop If   '${count}' > '0'
  Sleep     2
  Select From List By Value     xpath=//select[@id="documentType"]      notice
  Sleep     1
  # -== doc upload ==-
  Execute Javascript    $('button[ng-model="file"]').click()
  Sleep     1
  Choose File   xpath=//input[@type="file"]     ${ARGUMENTS[1]}
  Sleep     2
  # -== doc upload end ==-
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     2
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="upload()"]
  \   Exit For Loop If   '${count}' == '0'

Завантажити документ в лот
  [Arguments]  @{ARGUMENTS}
  [Documentation]   Uploading document for repoting
  ...      ${ARGUMENTS[0]} ==  user_name
  ...      ${ARGUMENTS[1]} ==  file_path
  ...      ${ARGUMENTS[2]} ==  tender_id
  ...      ${ARGUMENTS[3]} ==  lot_Id
  Log To Console    all args - @{ARGUMENTS}
  # :TODO add docs upload possibility with LOTS relation
  Reload Page
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  # Waiting for button appearance
  : FOR   ${INDEX}   IN RANGE   1   5
  \   Sleep     2
  \   ${count}=     Get Matching Xpath Count    xpath=//button[@ng-click="uploadDocument()"]
  \   Exit For Loop If   '${count}' > '0'
  # Interacting with button upload
  Click Element     xpath=//button[@ng-click="uploadDocument()"]
  Sleep     2
  # -== doc upload ==-
  Execute Javascript    $('button[ng-model="file"]').click()
  Sleep     2
  Choose File   xpath=//input[@type="file"]     ${ARGUMENTS[1]}
  Sleep     2
  # -== doc upload end ==-
  # Selecting Document relation
  Click Element     xpath=//select[@id="documentOf"]
  Select From List By Value     xpath=//select[@id="documentOf"]    lot
  Sleep     2
  Click Element     xpath=//select[@id="lot"]
  Sleep     2
  # Getting Label name by Argument value and relate it correctly
  ${label}=         Get Webelement    xpath=//option[contains(., '${ARGUMENTS[3]}')]
  ${label_text}=    Get Text          ${label}
  Log To Console    -== label - ${label_text} ==-
  Select From List By Label     xpath=//select[@id="lot"]    ${label_text}
  Sleep     3
  # Doc type selection
  Click Element     xpath=//select[@id="documentType"]
  Sleep     3
  Select From List By Value     xpath=//select[@id="documentType"]     notice
  Sleep     2
  # Upload doc
  Click Element     xpath=//button[@ng-click="upload()"]
  Sleep     2
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="upload()"]
  \   Exit For Loop If   '${count}' == '0'


Створити постачальника, додати документацію і підтвердити його
  [Arguments]   @{ARGUMENTS}
  [Documentation]   Adding user into reporting procedure
  ...      ${ARGUMENTS[0]} == user_name
  ...      ${ARGUMENTS[1]} == tender_uaid
  ...      ${ARGUMENTS[2]} == tender_data
  ...      ${ARGUMENTS[3]} == file_path
  # Getting information about participant
  ${supplier_name}=    Get From Dictionary     ${ARGUMENTS[2].data.suppliers[0].contactPoint}    name
  ${supplier_email}=   Get From Dictionary     ${ARGUMENTS[2].data.suppliers[0].contactPoint}    email
  ${supplier_phone}=   Get From Dictionary     ${ARGUMENTS[2].data.suppliers[0].contactPoint}    telephone
  ${supplier_site}=    Get From Dictionary     ${ARGUMENTS[2].data.suppliers[0].contactPoint}    url
  # Supplier address
  ${supplier_country}=  Get From Dictionary    ${ARGUMENTS[2].data.suppliers[0].address}     countryName
  ${supplier_city}=     Get From Dictionary    ${ARGUMENTS[2].data.suppliers[0].address}     locality
  ${supplier_zip}=      Get From Dictionary    ${ARGUMENTS[2].data.suppliers[0].address}     postalCode
  ${supplier_region}=   Get From Dictionary    ${ARGUMENTS[2].data.suppliers[0].address}     region
  ${supplier_street}=   Get From Dictionary    ${ARGUMENTS[2].data.suppliers[0].address}     streetAddress
  # Supplier identification number and Name
  ${supplier_edr}=         Get From Dictionary   ${ARGUMENTS[2].data.suppliers[0].identifier}   id
  ${supplier_legalName}=   Get From Dictionary   ${ARGUMENTS[2].data.suppliers[0].identifier}   legalName
  ${supplier_full_name}=   Get From Dictionary   ${ARGUMENTS[2].data.suppliers[0]}         name
  # Supplier value
  ${supplier_amount}=      Get From Dictionary   ${ARGUMENTS[2].data.value}   amount
  ${supplier_amount_int}=  Convert To String     ${supplier_amount}
  Sleep     3
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Wait Until Page Contains Element  xpath=//button[@ng-click="createAward()"]   10
  Click Element     xpath=//button[@ng-click="createAward()"]
  Sleep     2
  Input Text    ${locator.supplier_company_name}    ${supplier_full_name}
  Input Text    ${locator.supplier_legal_name}      ${supplier_legalName}
  Input Text    ${locator.supplier_url}             ${supplier_site}
  Input Text    ${locator.supplier_phone}           ${supplier_phone}
  Input Text    ${locator.supplier_name}            ${supplier_name}
  Input Text    ${locator.supplier_email}           ${supplier_email}
  Input Text    ${locator.supplier_zip}             ${supplier_zip}
  Input Text    ${locator.supplier_region}          ${supplier_region}
  Input Text    ${locator.supplier_locality}        ${supplier_city}
  Input Text    ${locator.supplier_streetAddress}   ${supplier_street}
  Click Element     xpath=//md-select[@ng-model="vm.award.suppliers[0].identifier.scheme"]
  Click Element     xpath=//md-option[@value="UA-EDR"]
  Sleep     1
  Input Text    ${locator.supplier_ua-id}       ${supplier_edr}
  Clear Element Text    id=award-value-amount
  Input Text    id=award-value-amount   ${supplier_amount_int}
  Click Element     xpath=//md-checkbox[@name="qualified"]
  Sleep     2
  Click Element     xpath=//button[@ng-click="vm.createAward()"]
  Sleep     4
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="vm.createAward()"]
  \   Exit For Loop If   '${count}' == '0'
  # Accepting the Participant
  Focus             xpath=//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]
  Click Element     xpath=//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]
  Sleep     2
  Execute Javascript    $('div[ng-model="file"]').click()
  Sleep     1
  Choose File   xpath=//input[@type="file"]     ${ARGUMENTS[3]}
  Sleep     2
  Click Element     xpath=//button[@ng-click="upload()"]
  : FOR   ${INDEX}   IN RANGE    1   5
  \   Sleep     3
  \   ${ok}=    Get Matching Xpath Count    xpath=//i[@class="glyphicon glyphicon-ok"]
  \   Exit For Loop If   '${ok}' > '0'
  \   Sleep     1
  Sleep     2
  Click Element     xpath=//button[@ng-click="accept()"]
  Sleep     2
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count   xpath=//button[@ng-click="accept()"]
  \   Exit For Loop If   '${count}' == '0'


Підтвердити підписання контракту
  [Arguments]   @{ARGUMENTS}
  [Documentation]   For Reporting procedure flow, pressing finish btn in Trades tab
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} == file_path
  log to console   arg0 - ${ARGUMENTS[0]}
  log to console   arg1 - ${ARGUMENTS[1]}
  log to console   arg2 - ${ARGUMENTS[2]}
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  Reload Page
  Sleep     3
  : FOR   ${INDEX}   IN RANGE    1    10
  \   Reload Page
  \   Log To Console   .   no_newline=true
  \   Sleep     3
  \   ${count}=   Get Matching Xpath Count    xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  \   Exit For Loop If   '${count}' > '0'
  Click Element     xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  # Waiting for Contracts Confirm modal window appear
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//form[@name="closeBidsForm"]
  \   Exit For Loop If   '${count}' > '0'
  # ${contruct_number}=    Convert To String    ${ARGUMENTS[2]}
  Input Text    id=contractNumber   'contruct_number'
  Sleep     20
  Click Element     xpath=//button[@ng-click="closeBids()"]
  # Waiting for Contracts Finish modal window hide
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//form[@name="closeBidsForm"]
  \   Exit For Loop If   '${count}' < '1'
  Sleep     2


Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${Complain}
  Fail  Не реалізований функціонал

порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${file_path}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
  Fail  Не реалізований функціонал

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Log To Console   Who is it_0 - ${ARGUMENTS[0]}
  Log To Console   Searching for UFOs - ${ARGUMENTS[1]}
  Switch browser   ${BROWSER_ALIAS}
  Sleep     5
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Go To    https://dev23.newtend.com/opc/provider/home/
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Viewer'  Go To    http://dev23.newtend.com/opc/provider/search/?pageNum=1&query=${ARGUMENTS[1]}
  Sleep     2
  ${tender_number}=   Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'   Convert To String    ${ARGUMENTS[1]}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'    Wait Until Page Contains Element        xpath=//input[@type="search"]
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'    Input Text      xpath=//input[@type="search"]     ${tender_number}
  Run Keyword If   '${ARGUMENTS[0]}' == 'Newtend_Owner'    Click Element   xpath=//div[@ng-click="search()"]
  Sleep     2
# waiting for search results
  : FOR   ${INDEX}   IN RANGE    1    7
  \   Reload Page
  \   Sleep     1
  \   Log To Console   .   no_newline=true
  \   Sleep     5
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@ui-sref="tenderView.overview({id: tender.cdb_id})"]/..//span[contains(text(), '${ARGUMENTS[1]}')]
  \   Exit For Loop If   '${count}' > '0'
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.overview({id: tender.cdb_id})"]/..//span[contains(text(), '${ARGUMENTS[1]}')]
  Sleep     2

# :TODO fix lots information extraction
Отримати інформацію із лоту
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  user_name
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  field_number     # like 'l-c24ec571'
  ...      ${ARGUMENTS[3]} ==  field_name
  Log to console    arg0 - ${ARGUMENTS[0]}
  Log to console    arg1 - ${ARGUMENTS[1]}
  Log to console    arg2 - ${ARGUMENTS[2]}
  Log to console    arg3 - ${ARGUMENTS[3]}
  Run Keyword And Return  Отримати лотову інформацію про ${ARGUMENTS[3]}    ${ARGUMENTS[2]}

Отримати лотову інформацію про title
  [Arguments]  ${field_number}
  ${lot_title}=     Get Text    xpath=//span[contains(text(), '${field_number}')]
  Log To Console    -==lot title - ${lot_title} ==-
  [Return]      ${lot_title}

Отримати лотову інформацію про value.amount
  [Arguments]  ${field_number}
  ${lot_value}=     Get Text    xpath=//*[contains(., '${field_number}')]//span[@ng-bind="lot.value.amount"]
  ${lot_value}=     convert_to_float    ${lot_value}
  Log To Console    -==lot value - ${lot_value} ==-
  [Return]      ${lot_value}

Отримати лотову інформацію про minimalStep.amount
  [Arguments]  ${field_number}
  ${lot_step_raw}=      Get Text    xpath=//*[contains(., '${field_number}')]//div[@class="block-info__text block-info__text--bold ng-binding"]
  ${lot_step}=      Get Substring   ${lot_step_raw}   0  -4
  ${lot_step}=      convert_to_float    ${lot_step}
  Log To Console    -==lot step - ${lot_step} ==-
  [Return]      ${lot_step}

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  user_name
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  item_strange_name
  ...      ${ARGUMENTS[3]} ==  field_name
  Log to console    arg0 - ${ARGUMENTS[0]}
  Log to console    arg1 - ${ARGUMENTS[1]}
  Log to console    arg2 - ${ARGUMENTS[2]}
#  Log to console    arg3 - ${ARGUMENTS[3]}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[2]}   #  ${ARGUMENTS[3]}

отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  1
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [Return]  ${return_value}

Отримати інформацію про causeDescription
  ${cause_description}=     Get Text    xpath=//div[@class="tender-causes__cause block-info"]/..//div[@ng-bind="tender.causeDescription"]
  [Return]      ${cause_description}

Отримати інформацію про cause
  ${cause_raw}=    Get Text    xpath=//div[@class="tender-causes__cause block-info"]/..//div[@id="view-tender-reasons"]
  ${cause}=        convert_to_newtend_normal   ${cause_raw}
  Log To Console   'Cause work word'
  [Return]      ${cause}

Отримати інформацію про contracts[0].status
# Navigate into trades --> select contract status
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  ${contr_status}=   Get Text   xpath=//div[@class="right"]/.//span[@class="status ng-binding"]
#  ${contr_status}=   Get Text   xpath=//span[@ng-if="vm.award.status === 'active'"]
  ${status}=    convert_to_newtend_normal   ${contr_status}
  [Return]  ${status}


отримати інформацію про title
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  ${title}=   отримати текст із поля і показати на сторінці   view_title
  [Return]  ${title}

отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   view_description
  [Return]  ${description}

отримати інформацію про tenderId
  ${tenderId}=   отримати текст із поля і показати на сторінці   tenderId
  [Return]  ${tenderId}

Отримати інформацію про budget.amount
  ${budget_amount_raw}=   Get Text  xpath=//div[@ng-bind="plan.budget.amount"]
  ${budget_amount}=     Convert To Number   ${budget_amount_raw}
  [Return]  ${budget_amount}

отримати інформацію про value.amount
  ${valueAmount}=   отримати текст із поля і показати на сторінці   view_value_amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  [Return]  ${valueAmount}

Отримати інформацію про value.currency    # UAH, RUB, USD
  ${currancy}=      Get Text    xpath=//div[@class="block-info__text block-info__text--large block-info__text--bold ng-binding"]
  ${currancy_correct}=    Convert To String    ${currancy.split(' ')[1]}
  log to console      currency name - '${currancy_correct}'
  [Return]  ${currancy_correct}

Отримати інформацію про value.valueAddedTaxIncluded   # NDS
  ${currancy}=        Get Text    xpath=//div[@class="block-info__text block-info__text--large block-info__text--bold ng-binding"]
  ${currancy_full}=   Split String    ${currancy}
  ${currancy_1}=      Get Substring   ${currancy_full}     1  2
  ${vat_1}=           Get Substring   ${currancy_full}    -2  -1
  ${vat_2}=           Get Substring   ${currancy_full}    -1
  ${vat_catenate}=    Get Substring   ${currancy}     -9
  ${vat_catenate}=    convert_to_newtend_normal    ${vat_catenate}
  [Return]  ${vat_catenate}

Отримати інформацію про procuringEntity.address.countryName
# Reporting procedure - country
  ${customer_country}=  отримати текст із поля і показати на сторінці   view_country
  ${c_country}=     Get Substring   ${customer_country}     0     -1
  log to console    country -  ${c_country}
  [Return]  ${c_country}

Отримати інформацію про procuringEntity.address.locality
# Reporting procedure - city
  ${customer_locality}=     отримати текст із поля і показати на сторінці   view_locality
  ${c_locality}=    Get Substring   ${customer_locality}    0    -1
  log to console    city - ${c_locality}
  [Return]  ${c_locality}

Отримати інформацію про procuringEntity.address.postalCode
# Reporting procedure - zip
  ${customer_zip}=      отримати текст із поля і показати на сторінці    view_zip
  ${c_zip}=     Get Substring   ${customer_zip}     0   -1
  log to console    zip - ${c_zip}
  [Return]  ${c_zip}

Отримати інформацію про procuringEntity.address.region
# Reporting procedure - region oblast
  ${customer_region}=   отримати текст із поля і показати на сторінці   view_region
  ${c_region}=      Get Substring   ${customer_region}  0   -1
  log to console    region - ${c_region}
  [Return]  ${c_region}

Отримати інформацію про procuringEntity.address.streetAddress
# Reporting procedure - street
  ${customer_street}=   отримати текст із поля і показати на сторінці   view_street
  ${c_street}=      Get Substring   ${customer_street}  0
  log to console    street - ${c_street}
  [Return]   ${c_street}

Отримати інформацію про procuringEntity.contactPoint.name
# Reporting procedure - customer contact name
  ${contact_name}=  Get Webelements    xpath=//div[@class="block-info"]/..//div[@class="block-info__text block-info__text--bold ng-binding"]
  ${name_text}=     Get Text    ${contact_name[-1]}
  log to console    name - ${name_text}
  [Return]   ${name_text}

Отримати інформацію про procuringEntity.contactPoint.telephone
# Reporting procedure - customer phone
  ${phone_block}=   Get Webelements     xpath=//div[@class="block-info__text ng-binding"]
  ${phone}=         Get Text    ${phone_block[-2]}
  [Return]   ${phone}

Отримати інформацію про procuringEntity.contactPoint.url
# Reporting procedure - customer email, unfortunately
  Fail      Not realized

Отримати інформацію про procuringEntity.identifier.legalName
# Reporting procedure - official name
  ${official_name}=    Get Text    xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text block-info__text--big block-info__text--bold ng-binding"]
  log to console    off name - ${official_name}
  [Return]   ${official_name}

Отримати інформацію про procuringEntity.identifier.scheme
# Reporting procedure - Customer UA-EDR scheme or like this
  ${lines}=    Get Webelements     xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text ng-binding"]
  ${line}=     Get Text     ${lines[-1]}
  ${scheme}=   Get Substring     ${line}    -6
  [Return]    ${scheme}

Отримати інформацію про procuringEntity.identifier.id
# Reporting procedure - Customer EDR ID
  ${lines}=   Get Webelements     xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text ng-binding"]
  ${line}=    Get Text     ${lines[-1]}
  ${id}=      Get Substring     ${line}   0  -8
  [Return]      ${id}

Отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [Return]  ${minimalStepAmount}

Отримати інформацію про documents[0].title
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     4
  ${document_title}=    Get Text    xpath=//h3[contains(., 'Procurement documentation')]/..//a[@class="ng-binding"]
  log to Console    doc title - '${document_title}'
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     4
  [Return]      ${document_title}

Отримати інформацію про awards[0].documents[0].title
# Award document title
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     2
  ${award_doc}=     Get Text    xpath=//h3[contains(., 'Qualification protocol')]/..//a[@class="ng-binding"]
  [Return]      ${award_doc}

Отримати інформацію про awards[0].status
# Award user status - winner
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  ${award_status}=   Get Text   xpath=//span[@ng-if="vm.award.status === 'active'"]
  ${award_status}=   convert_to_newtend_normal   ${award_status}
  [Return]      ${award_status}

Отримати інформацію про awards[0].suppliers[0].address.countryName
# Winner Country name
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_country}=    Convert To String   ${address.split(', ')[1]}
  [Return]      ${winner_country}

Отримати інформацію про awards[0].suppliers[0].address.locality
# Winner City
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_city}=   Convert To String   ${address.split(', ')[3]}
  [Return]      ${winner_city}

Отримати інформацію про awards[0].suppliers[0].address.postalCode
# Winner Zip code
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_zip}=   Convert To String   ${address.split(', ')[0]}
  [Return]      ${winner_zip}

Отримати інформацію про awards[0].suppliers[0].address.region
# Winner Oblast
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_region}=   Convert To String   ${address.split(', ')[2]}
  [Return]      ${winner_region}

Отримати інформацію про awards[0].suppliers[0].address.streetAddress
# Winner street
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${len_addr}=  Get Length  ${address.split(', ')}
  ${winner_street}=   Convert To String   ${address.split(', ')[4]}
  ${winner_house}=    Convert To String   ${address.split(', ')[5]}
  ${winner_flat}=  Run Keyword If  '${len_addr}' == '7'   Convert To String   ${address.split(', ')[6]}
  ${long_addr}=    Run Keyword If  '${len_addr}' == '7'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}   ${winner_flat}
  ${short_addr}=   Run Keyword If  '${len_addr}' == '6'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}
  ${new_address}=  Run Keyword If  '${len_addr}' == '6'   Get Substring   ${short_addr}  0    ELSE   Get Substring   ${long_addr}   0
  [Return]      ${new_address}

Отримати інформацію про awards[0].suppliers[0].contactPoint.telephone
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${phone_number}=  Get Text    ${award_raws[-6]}
  [Return]    ${phone_number}

Отримати інформацію про awards[0].suppliers[0].contactPoint.name
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${name}=    Get Text    ${award_raws[5]}
  [Return]    ${name}

Отримати інформацію про awards[0].suppliers[0].contactPoint.email
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${email}=     Get Text    ${award_raws[-5]}
  [Return]      ${email}

Отримати інформацію про awards[0].suppliers[0].identifier.scheme
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${edr}=     Get Text    ${award_raws[3]}
  [Return]    ${edr}

Отримати інформацію про awards[0].suppliers[0].identifier.legalName
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${legal_name}=    Get Text    ${award_raws[2]}
  [Return]      ${legal_name}

Отримати інформацію про awards[0].suppliers[0].identifier.id
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${id}=      Get Text    ${award_raws[4]}
  [Return]    ${id}

Отримати інформацію про awards[0].suppliers[0].name
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${suppl_name}=    Get Text    ${award_raws[2]}
  [Return]    ${suppl_name}

Отримати інформацію про awards[0].value.valueAddedTaxIncluded
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${vat}=      Get Text    ${award_raws[-1]}
  ${vat_is}=   Get Substring   ${vat}   -9
  ${vat_ready}=     convert_to_newtend_normal   ${vat_is}
  [Return]     ${vat_ready}

Отримати інформацію про awards[0].value.currency
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${currancy}=    Get Text    ${award_raws[-1]}
  ${currancy}=    Convert To String     ${currancy.split('${SPACE}')[1]}
  [Return]    ${currancy}

Отримати інформацію про awards[0].value.amount
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${amount}=    Get Text    ${award_raws[-1]}
  ${amount}=    Convert To String   ${amount.split('.')[0]}
  ${amount}=    Convert To Integer  ${amount}
  [Return]    ${amount}

Отримати інформацію про awards[0].complaintPeriod.endDate
# Negotiation procedure
  ${period_string}=   Get text    xpath=//div[@ng-if="vm.award.complaintPeriod.endDate"]/.//span[@class="ng-binding"]
  ${raw_period}=      Get Substring   ${period_string}    -19
  ${period}=    get_time_with_offset    ${raw_period}
  [Return]    ${period}

Отримати інформацію із предмету
# Super0-mega loops to interact with Items
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  user_name
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  field_number
  ...      ${ARGUMENTS[3]} ==  field_name
  Log to console    arg0 - ${ARGUMENTS[0]}
  Log to console    arg1 - ${ARGUMENTS[1]}
  Log to console    arg2 - ${ARGUMENTS[2]}
  Log to console    arg3 - ${ARGUMENTS[3]}
  Log to console    arg_list - '@{ARGUMENTS}'
  Run Keyword And Return  Отримати інформацію із ${ARGUMENTS[3]}    ${ARGUMENTS[2]}

Отримати інформацію із description
  [Arguments]    @{ARGUMENTS}
  [Documentation]
  ...       ${ARGUMENTS[0]} == user_name
  ...       ${ARGUMENTS[1]} == tender_uaid
  ...       ${ARGUMENTS[2]} == field_number
  ...       ${ARGUMENTS[3]} == field_name
  log to console    list of args - '@{ARGUMENTS}'
  log to console    "it's OK Bro!!"
  ${item_description}=   Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/.//div[@id="view-item-description"]
  log to console    item description - '${item_description}'
  [Return]    ${item_description}

Отримати інформацію із classification.scheme
  [Arguments]    @{arguments}
  ${cpvs}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[contains(., '021:2015')]    # /..//div[@class="block-info"]/..//div[@class="block-info__text ng-binding"]
  ${cpv}=    Get Text    ${cpvs[2]}
  ${scheme}=    convert_to_newtend_normal   ${cpv}
  [Return]   ${scheme}

Отримати інформацію із classification.id
  [Arguments]    @{arguments}
  ${cpvs}=       Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${class_id}=   Get Text        ${cpvs[2]}
  ${class_id}=   Get Substring   ${class_id}   0   10
  [Return]       ${class_id}

Отримати інформацію із classification.description
  [Arguments]    @{arguments}
  ${cpvs}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${class_description}=  Get Text   ${cpvs[2]}
  ${class_description}=  Get Substring   ${class_description}  13
  [Return]       ${class_description}

Отримати інформацію із additionalClassifications.scheme
  [Arguments]    @{arguments}
  ${dkpps}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[contains(., 'ДКПП')]
  ${dkpp}=    Get Text      ${dkpps[2]}
  ${dkpp_scheme}=   convert_to_newtend_normal   ${dkpp}
  log to console    DKPP Scheme - ${dkpp_scheme}
  [Return]      ${dkpp_scheme}

Отримати інформацію із additionalClassifications.id
  [Arguments]    @{arguments}
  ${dkpps}=      Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${dkpp_id}=    Get Text        ${dkpps[3]}
  ${dkpp_id}=    Convert To String   ${dkpp_id.split('${SPACE}-${SPACE}')[0]}
  Log to console    DKPP ID text - ${dkpp_id}
  [Return]       ${dkpp_id}

Отримати інформацію із additionalClassifications.description
  [Arguments]    @{arguments}
  ${dkpps}=      Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${dkpp_id}=    Get Text        ${dkpps[3]}
  ${dkpp_descr}=    Convert To String   ${dkpp_id.split('${SPACE}-${SPACE}')[1]}
  [Return]      ${dkpp_descr}

Отримати інформацію із quantity
# Convert to Integer
  [Arguments]   @{arguments}
  ${quantity}=   Get Text   xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//span[@ng-bind="vm.item.quantity"]
#  ${quantity}=   Get Text   ${quantity_raw[0]}
  ${quantity}=   Convert To Integer   ${quantity}
  [Return]      ${quantity}

Отримати інформацію із unit.name
  [Arguments]   @{arguments}
  ${unit_name}=    Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//span[@class="unit ng-binding"]
  log to console   unit name - ${unit_name}
  ${unit_name}=     convert_to_newtend_normal   ${unit_name}
  [Return]      ${unit_name}

Отримати інформацію із unit.code
  [Arguments]   @{arguments}
  Fail    Not Realized

Отримати інформацію із deliveryDate.startDate
  [Arguments]   @{arguments}
  ${delivery_start_date}=     Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@ng-bind="(vm.item.deliveryDate.startDate | date:'yyyy-MM-dd HH:mm:ss')"]
  Log To Console    delivery end date - '${delivery_start_date}'
  [Return]   ${delivery_start_date}

Отримати інформацію із deliveryDate.endDate
  [Arguments]   @{arguments}
  ${delivery_end_date}=     Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@ng-bind="(vm.item.deliveryDate.endDate | date:'yyyy-MM-dd HH:mm:ss')"]
  Log To Console    delivery end date - '${delivery_end_date}'
  [Return]   ${delivery_end_date}

Отримати інформацію із deliveryLocation.latitude
  [Arguments]   @{arguments}
  Fail    Not Realized

Отримати інформацію із ddeliveryAddress.countryName_ru
  [Arguments]   @{arguments}
  Fail   Not Realized

Отримати інформацію із deliveryAddress.countryName_en
  [Arguments]   @{arguments}
  Fail   Not Realized

Отримати інформацію із deliveryAddress.countryName
# Country name
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${country}=   Convert To String   ${country name.split(', ')[1]}
  log to console    new country - '${country}'
  [Return]   ${country}

Отримати інформацію із deliveryAddress.postalCode
# Zip code
  [Arguments]   @{arguments}
  ${delivery_zip}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${delivery_zip}=   Get Text   ${delivery_zip[-1]}
  ${zip}=   convert to string  ${delivery_zip.split(', ')[0]}
  Log To Console    ZZZZIIIIpppp - '${zip}'
  [Return]    ${zip}

Отримати інформацію із deliveryAddress.region
# Oblast region
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${region}=    Convert To String   ${country_name.split(', ')[2]}
  Log To Console    oblast - '${region}'
  [Return]   ${region}

Отримати інформацію із deliveryAddress.locality
# City
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${locality}=  Convert To String   ${country_name.split(', ')[3]}
  Log To Console    city - '${locality}'
  [Return]      ${locality}

Отримати інформацію із deliveryAddress.streetAddress
  [Arguments]   @{arguments}
# Delivery Address - just street
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${len_addr}=       Get Length  ${country_name.split(', ')}
  ${winner_street}=  Convert To String   ${country_name.split(', ')[4]}
  ${winner_house}=   Convert To String   ${country_name.split(', ')[5]}
  ${winner_flat}=   Run Keyword If  '${len_addr}' == '7'   Convert To String   ${country_name.split(', ')[6]}
  ${long_addr}=     Run Keyword If  '${len_addr}' == '7'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}   ${winner_flat}
  ${short_addr}=    Run Keyword If  '${len_addr}' == '6'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}
  ${new_address}=   Run Keyword If  '${len_addr}' == '6'   Get Substring   ${short_addr}  0   -1   ELSE   Get Substring   ${long_addr}   0   -1
  [Return]      ${new_address}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  userName
  ...      ${ARGUMENTS[1]} ==  tenderID
  ...      ${ARGUMENTS[2]} ==  fieldName
  ...      ${ARGUMENTS[3]} ==  fieldValue
  Log To Console    -== @{ARGUMENTS} ==-
  Switch browser   ${BROWSER_ALIAS}
  Sleep     2
  Reload Page
  Sleep     3
  Click Element     ${locator.edit_tender}
  # Loop for edit progress start
  : FOR   ${INDEX}  IN RANGE    1   5
  \   Sleep     2
  \   ${submit_sign}=     Get Matching Xpath Count    xpath=//button[@id="submit-btn"]
  \   Exit For Loop If  '${submit_sign}' > '0'
  Sleep     2
  # :TODO realize Edit date Keyword
  Run Keyword If    '${ARGUMENTS[2]}' == 'tenderPeriod.endDate'   Edit date        ${ARGUMENTS[3]}
  Run Keyword If    '${ARGUMENTS[2]}' != 'tenderPeriod.endDate'   Edit some field  ${ARGUMENTS[2]}   ${ARGUMENTS[3]}
  # Confirm Editing process
  Sleep     2
  Focus     xpath=//button[@id="submit-btn"]
  Sleep     1
  Click Element     xpath=//button[@id="submit-btn"]
 # A Loop to find 'edit' btn
  : FOR   ${INDEX}  IN RANGE    1   7
  \   Sleep     3
  \   ${edit_sign}=     Get Matching Xpath Count    xpath=//button[@id="edit-tender-btn"]
  \   Exit For Loop If  '${edit_sign}' > '0'

Edit date
  [Arguments]   ${argument}
  Log To Console    -== ${argument} ==-
  Focus     id=end-date-registration
  Sleep     1
  ${end_date_minutes}=    Get Webelements   xpath=//table[@ng-model="tender.tenderPeriod.endDate"]/.//input[@ng-change="updateMinutes()"]
  ${end_minutes}=         Get Substring     ${argument}     14      16
  Sleep     1
  Clear Element Text      ${end_date_minutes[-1]}
  Sleep     2
  Input Text    ${end_date_minutes[-1]}     ${end_minutes}
  Sleep     1

Edit some field
  [Arguments]   @{arguments}
  ...    ${ARGUMENTS[0]} == fieldName - description, might be
  ...    ${ARGUMENTS[1]} == fieldValue
  Focus     ${locator.edit.${ARGUMENTS[0]}}
  Sleep     1
  Clear Element Text    ${locator.edit.${ARGUMENTS[0]}}
  Sleep     2
  Input Text    ${locator.edit.${ARGUMENTS[0]}}     ${ARGUMENTS[1]}
  Sleep     2

Змінити лот
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  userName
  ...      ${ARGUMENTS[1]} ==  tenderID
  ...      ${ARGUMENTS[2]} ==  lotName
  ...      ${ARGUMENTS[3]} ==  fieldName - value.amount and minimalStep.amount
  ...      ${ARGUMENTS[4]} ==  fieldValue
  Log To Console    -== args list - @{ARGUMENTS} ==-
  Sleep     2
  # Navigate to tender overview
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  # Getting into the edit process
  Click Element     id=edit-tender-btn
  Sleep     2
  # Making changes for lot budget
  Focus     xpath=//input[@id="lot"]
  Sleep     1
  Click Element  xpath=//input[@id="lot"]
  Sleep     2
  Focus     xpath=//ng-form[@name="lotForm"]
  Sleep     2
  Run Keyword If    '${ARGUMENTS[3]}' == 'value.amount'         Edit lot budget     ${ARGUMENTS[2]}     ${ARGUMENTS[4]}
  Run Keyword If    '${ARGUMENTS[3]}' == 'minimalStep.amount'   Edit lot step       ${ARGUMENTS[2]}     ${ARGUMENTS[4]}
  Sleep     2
  Click Element  xpath=//button[@ng-click="save()"]
  Sleep     2
  Focus     xpath=//button[@id="submit-btn"]
  Sleep     1
  Click Element     xpath=//button[@id="submit-btn"]
  Sleep     2

Edit lot budget
  [Arguments]   @{arguments}
  Log To Console    -== arrgos @{arguments} ==-
  # :TODO Seems tobe real hardcode, need to change after FE will make corrections
  ${lot_field}=    Get Webelement     xpath=//div[contains(., '${ARGUMENTS[0]}')]//input[@ng-model="lot.value.amount"]
  Focus     ${lot_field}
  Sleep     2
  Clear Element Text    ${lot_field}
  Sleep     2
#  Focus     xpath=//input[@id="budget0"]
#  Sleep     1
#  Clear Element Text    xpath=//input[@id="budget0"]
#  Sleep     1
  ${value}=     convert_budget     ${ARGUMENTS[1]}
  Input Text    ${lot_field}       ${value}
  Sleep     2

Edit lot step
  [Arguments]   @{arguments}
  ${lot_step}=      Get Webelement    xpath=//div[contains(., '${ARGUMENTS[0]}')]//input[@ng-model="lot.minimalStep.amount"]
  Focus     ${lot_step}
#  Focus     xpath=//input[@ng-model="lot.minimalStep.amount"]
  Sleep     2
  Clear Element Text    ${lot_step}
#  Clear Element Text    xpath=//input[@ng-model="lot.minimalStep.amount"]
  Sleep     2
  ${value}=     convert_budget     ${ARGUMENTS[1]}
  Input Text    ${lot_step}        ${value}
#  Input Text    xpath=//input[@ng-model="lot.minimalStep.amount"]    ${value}
  Sleep     2

отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   view.procuringEntity.name
  [return]  ${procuringEntity_name}

отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=    Get Text     xpath=//div[@id="start-date-enquiry-enquiryPeriod"]/./span[@class="period-date ng-binding"]  # enquiryPeriod.StartDate
  Log To Console    -==${enquiryPeriodStartDate}==-
  [return]  ${enquiryPeriodStartDate}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=    Get Text     xpath=//div[@id="end-date-enquiryPeriod"]/./span[@class="period-date ng-binding"]
  Log To Console    -==End date - ${enquiryPeriodEndDate}==-
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   Get Text   xpath=//div[@id="start-date-enquiry-tenderPeriod"]/./span[@class="period-date ng-binding"]
  [return]  ${tenderPeriodStartDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=     Get Text   xpath=//div[@id="end-date-tenderPeriod"]/./span[@class="period-date ng-binding"]
  [return]  ${tenderPeriodEndDate}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}  multi
  ${items}=         Get From Dictionary   ${ADDITIONAL_DATA.data}               items
  Switch Browser    ${BROWSER_ALIAS}
  Wait Until Page Contains Element   ${locator.edit_tender}    10
  Click Element                      ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.add_item}  10
  Input text   ${locator.edit.description}   description
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   забрати позицію
  Wait Until Page Contains Element   ${locator.save}           10
  Click Element   ${locator.save}
  Wait Until Page Contains Element   ${locator.description}    20

додати позицію
###  Не видно контролів додати пропозицію в хромі, потрібно скролити, скрол не працює. Обхід: додати лише 1 пропозицію + редагувати description для скролу.
  Click Element    ${locator.edit.add_item}
  Додати придмет   ${items[1]}   1

забрати позицію
  Click Element   xpath=//a[@title="Добавить лот"]/preceding-sibling::a

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Switch Browser    ${BROWSER_ALIAS}
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element   xpath=//a[contains(text(), "Уточнения")]
  Wait Until Page Contains Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]   20
  Click Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="title"]   10
  Input text   xpath=//input[@ng-model="title"]   ${title}
  Input text    xpath=//textarea[@ng-model="message"]   ${description}
  Click Element   xpath=//div[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  Reload Page
  Sleep     5

отримати інформацію про QUESTIONS[0].title
  Wait Until Page Contains Element   xpath=//span[contains(text(), "Уточнения")]   20
  Click Element              xpath=//span[contains(text(), "Уточнения")]
  Wait Until Page Contains   Вы не можете задавать вопросы    20
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].title
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].description
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].description
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].date
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
  ${resp}=   Change_day_to_month   ${resp}
  [return]  ${resp}

Change_day_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${rest}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [return]  ${return_value}
