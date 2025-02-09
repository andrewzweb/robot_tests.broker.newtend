*** Settings ***
Resource  ../../newtend.robot

*** Variables ***
${data}                       hash

*** Keywords ***

Edit Tender Title and Description
  [Arguments]  ${tender_data}
  Log To Console  [+] Edit tender title and description
  Wait Until Page Contains Element  id=tender-title     20
  ${title}=         Get From Dictionary   ${tender_data.data}  title
  ${description}=   Get From Dictionary   ${tender_data.data}  description
  Input text   ${locator.title}  ${title}
  Input text   ${locator.edit.description}   ${description} 

  Edit Feasible Element  ${tender_data.data}  title_en  Input Text  ${locator.edit_tender_title_en}
  Edit Feasible Element  ${tender_data.data}  description_en  Input Text  ${locator.edit_tender_description_en}
  CustomLog  [+] Edit Title And Description

Edit Features
  [Arguments]  ${tender_data}

  Log To Console  [+] Edit tender Features
  # data
  ${procurementMethodType}=  Get From Dictionary  ${tender_data.data}  procurementMethodType
  ${data.features_data}=  Get From Dictionary  ${tender_data.data}  features
  ${data.feature_data}=  Get From List  ${data.features_data}  0
  Create Feature  ${data.feature_data}  ${procurementMethodType}
  Sleep  3

Create Feature
  [Arguments]  @{ARGS}
  ${feature_data}=     Set Variable  ${ARGS[0]}
  ${procurementMethodType}=  Set Variable  ${ARGS[1]}
  #[Arguments]  ${feature_data}
  [Documentation]
  ...  features:
  ...    -   code: 4cde2547611e469991610afdbe39f5f6
  ...        description: Гильце стругнути заперти пооблапувати тринькало ошпарити кантурь
  ...            утинок приймачка муравчаний буба повиводити убраний постояльний.
  ...        enum:
  ...        -   title: слідити
  ...            value: 0.05
  ...        -   title: вихрюватий
  ...            value: 0.01
  ...        -   title: жмикрутський
  ...            value: 0
  ...        featureOf: tenderer
  ...        title: 'f-bc9918bf: Літній дітки раз цяв!.'
  ...        title_en: 'f-b360e661: Ad eos qui ut dicta.'
  ...        title_ru: 'f-360437d2: Рэктэквуэ ыёюз лыгимуз мэль ывыртятюр рыквюы.'

  Log To Console  [+] Create tender Features

  # data
  ${data}=  Set Variable  0
  ${data.feature_description}=  Get From Dictionary  ${feature_data}  description
  ${data.feature_relation_of}=  Get From Dictionary  ${feature_data}  featureOf
  ${data.feature_title}=  Get From Dictionary  ${feature_data}  title
  ${data.feature_description}=  Get From Dictionary  ${feature_data}  description

  # wait popUp form
  Focus  xpath=//input[@id="qualityIndicator"]
  Wait And Click  xpath=//input[@id="qualityIndicator"]

  Sleep  3

  Wait And Type  xpath=//input[@id="quality_title_0"]  ${data.feature_title}
  Edit Feasible Element  ${feature_data}  title_en  Wait And Type  xpath=//input[@id="quality_title_en_0"]
  Wait And Type  xpath=//input[@id="quality_description_0"]   ${data.feature_description}
  Edit Feasible Element  ${feature_data}  description  Wait And Type  xpath=//input[@id="quality_description_en0"]
  Select From List By Value  xpath=//select[@id="quality_feature_Of_0"]  ${data.feature_relation_of}

  # TODO
  # select features relation with lot or item

  ${data_enum}=  Get From Dictionary  ${feature_data}  enum
  ${count_enum}=  Get length  ${data_enum}

  ${tender_type_with_different_default_count_features}=  black_list_tender_for_feature
  ${status_speciat_tender}=  Run Keyword If  '${procurementMethodType}' in ${tender_type_with_different_default_count_features}  Set Variable  True
  ...  ELSE  Set Variable  False

  Log To Console  [${status_speciat_tender}] Tender in black list

  Run Keyword If  ${status_speciat_tender}  Wait And Click  xpath=//a[@id="add-option-0-1"]
  
  : FOR   ${number_enum}  IN RANGE   ${count_enum}
  \  ${num_enum}=  Convert To Integer  ${number_enum}
  \  ${enum_title}=   Get From Dictionary  ${data_enum[${number_enum}]}   title
  \  ${enum_value}=   Get From Dictionary  ${data_enum[${number_enum}]}   value
  \  ${enum_value}=   convert_enum_str_to_int  ${enum_value}
  \  ${edit_feature_enum_title}=  Get WebElement  xpath=//input[@name="option_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_title}  ${enum_title}
  \  ${edit_feature_enum_value}=  Get WebElement  xpath=//input[@name="optionWeight_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_value}  ${enum_value}
  \  ${edit_feature_enum_description}=  Get WebElement  xpath=//input[@name="optionDescription_0_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_description}  ${enum_title}
  \  # add one form
  \  #
  \  ${st1}=  Evaluate  ${number_enum} < ${count_enum}-1
  \  
  \  #Log To Console  ${num_enum}: ${st1} | ${status_speciat_tender}
  \  #Log To Console  ${procurementMethodType} | ${tender_type_with_different_default_count_features}
  \
  \  Run Keyword If  ${st1} and not ${status_speciat_tender}  Wait And Click  xpath=//a[@id="add-option-0-${number_enum}"]
  \  Sleep  1

  # click to save features
  Wait And Click  ${locator.edit_feature_save_form}
  Sleep  20

Delete Feature
  [Arguments]  ${feature_id}

  Log To Console  [*] Delete feature: ${feature_id}

  # open
  ${locator_button_open_features_list}=  Set Variable  xpath=//input[@id="qualityIndicator"]
  Wait And Click  ${locator_button_open_features_list}
  Sleep  2
  ${feature_elements}=  Get WebElements  xpath=//div[@ng-repeat="item in features track by $index"]
  ${count_features}=  Get Length  ${feature_elements}
  Log To Console  [i] Count features ${count_features}
  ${feature_title_elements}=  Get WebElements  xpath=//div[@ng-repeat="item in features track by $index"]/div/div/input[@ng-model="item.title"]

  :FOR  ${index}  IN RANGE  ${count_features}
  \  ${id}=  Set Variable  quality_title_${index}
  \  ${current_title}=  Get Element Attribute  xpath=//input[@id='${id}']@value
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_title}  ${feature_id}
  \  Log To Console  [ ] delete ${index}? : ${is_need_element}
  \  Run Keyword If  ${is_need_element} == True    Wait And Click  xpath=//a[@id="remove_feature_${index}"]
  \  Exit For Loop IF  ${is_need_element} == True

  # close
  # click to save features
  Wait And Click  ${locator.edit_feature_save_form}
  Sleep  5


Delete All Features
  # delete all
  Log To Console  [*] Delete ALL feature:
  Wait And Click  xpath=//span[@ng-click="clearList(tender.features)"]

Add New Feature
  [Arguments]  @{ARGS}
  ${feature_data}=     Set Variable  ${ARGS[0]}
  Log To Console  ------------ New Feature ----------------
  Log To Console  ${feature_data}
  Log To Console  ------------ END New Feature-------------
  # open popup for create new feature

  ${locator_button_open_features_list}=  Set Variable  xpath=//input[@id="qualityIndicator"]
  Wait And Click  ${locator_button_open_features_list}

  ${locator_button_add_features_item}=  Set Variable  xpath=//a[@id="add_feature"]
  Wait And Click  ${locator_button_add_features_item}

  # data
  ${data.feature_description}=  Get From Dictionary  ${feature_data}  description
  ${data.feature_relation_of}=  Get From Dictionary  ${feature_data}  featureOf
  ${data.feature_title}=  Get From Dictionary  ${feature_data}  title
  ${data.feature_description}=  Get From Dictionary  ${feature_data}  description

  # wait popUp form
  #Focus  ${locator.edit_feature_add_button}
  #Wait And Click  ${locator.edit_feature_add_button}

  Sleep  3
  Wait And Type  xpath=//input[@id="quality_title_1"]  ${data.feature_title}
  Edit Feasible Element  ${feature_data}  title_en  Wait And Type  xpath=//input[@id="quality_title_en_1"]
  Wait And Type  xpath=//input[@id="quality_description_1"]     ${data.feature_description}
  Edit Feasible Element  ${feature_data}  description  Wait And Type  xpath=//input[@id="quality_description_en1"]
  Select From List By Value  xpath=//select[@id="quality_feature_Of_1"]  ${data.feature_relation_of}

  # TODO
  # select features relation with lot or item

  ${data_enum}=  Get From Dictionary  ${feature_data}  enum
  ${count_enum}=  Get length  ${data_enum}

  : FOR   ${number_enum}  IN RANGE   ${count_enum}
  \  ${num_enum}=  Convert To Integer  ${number_enum}
  \  ${enum_title}=   Get From Dictionary  ${data_enum[${number_enum}]}   title
  \  ${enum_value}=   Get From Dictionary  ${data_enum[${number_enum}]}   value
  \  Log To Console  [.] Enum value: ${enum_value}
  \  ${enum_value}=   convert_enum_str_to_int  ${enum_value}
  \  ${edit_feature_enum_title}=  Get WebElement  xpath=//input[@name="option_1_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_title}  ${enum_title}
  \  ${edit_feature_enum_value}=  Get WebElement  xpath=//input[@name="optionWeight_1_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_value}  ${enum_value}
  \  ${edit_feature_enum_description}=  Get WebElement  xpath=//input[@name="optionDescription_1_${number_enum}"]
  \  Wait And Type  ${edit_feature_enum_description}  ${enum_title}
  \  # add one form
  \  Sleep  2
  \  Run Keyword If  ${number_enum} < ${count_enum}-1  Wait And Click  xpath=//a[@id="add-option-1-${num_enum}"]

  Capture Page Screenshot
  # click to save features
  Wait And Click  ${locator.edit_feature_save_form}

  Sleep  10

  Capture Page Screenshot  ${OUTPUTDIR}/custom-screenshot-{index}.png



Edit Budget In Reporting
  [Arguments]  ${tender_data}
  # ====== budget ======

  Log To Console  [+] Edit budget in Reporting
  ${budget}=        Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Get From Dictionary   ${tender_data.data.value}   amount

  ## Getting some Data according to procedure's type -== Main Block 1 ==-
  # Minimal step for all procedures except two
  ${step_rate}=   Run Keyword If  '${procurementMethodType}' != 'reporting' and '${procurementMethodType}' != 'negotiation'  Get From Dictionary   ${tender_data.data.minimalStep}   amount

  ${valid_budget}=    Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']    convert_budget    ${budget}
  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Input text    ${locator.value.amount}    ${valid_budget}

  Run Keyword If   '${procurementMethodType}' in ['reporting', 'negotiation']   Click Element     id=with-nds

Edit Budget In BelowThreshold
  [Arguments]  ${tender_data}
  CustomLog  [+] Edit Budget in BelowThreshold

  Focus     id=with-nds
  Click Element     id=with-nds
  
  ${procurement_value}=  Get From Dictionary   ${tender_data.data}  value
  ${budget}=  convert_budget  ${procurement_value.amount}
  Input Text   id=budget  ${budget}

  ${if_minimal_step_in_dict}=  Exist key in dict  ${tender_data.data}  minimalStep
  ${procurement_step}=  Run Keyword If  ${if_minimal_step_in_dict} == True   Get From Dictionary   ${tender_data.data}   minimalStep
  ${minimalStep}=  Run Keyword If  ${if_minimal_step_in_dict} == True  convert_budget  ${procurement_step.amount}
  Run Keyword If  ${if_minimal_step_in_dict}  Input Text   id=step     ${minimalStep}

Edit Choise Category Tender
  [Arguments]  ${tender_data}
  Log To Console  [+] Edit Choise Category Tender
  # Filling the Main Procurement category
  ${procurementCategory}=  Get From Dictionary   ${tender_data.data}   mainProcurementCategory
  ${procurementCategory_field}=  Get Webelement  id=mainProcurementCategory
  Select From List By Value   ${procurementCategory_field}   ${procurementCategory}
  
If negotiation
  CustomLog  [+] If negotiation
    
  # Negotiation reson for Negotiation procedures only
  ${procurementMethodType}=  Get From Dictionary   ${tender_data.data}   procurementMethodType
  ${cause}=        Run Keyword If  '${procurementMethodType}' == 'negotiation'   Get From Dictionary   ${tender_data.data}   cause
  ${cause_descr}=  Run Keyword If  '${procurementMethodType}' == 'negotiation'   Get From Dictionary   ${tender_data.data}   causeDescription
  # Negotiation Main Block fill
  Run Keyword If   '${procurementMethodType}' == 'negotiation'   Input text   ${locator.cause_descr}    ${cause_descr}
  Run Keyword If   '${procurementMethodType}' == 'negotiation'   Select From List By Value    xpath=//select[@id="reason"]  ${cause}

Edit Date For Tender
  [Arguments]  ${tender_data}
  CustomLog  [+] Edit Date For Tender
  ${procurementMethodType}=  Get From Dictionary   ${tender_data.data}   procurementMethodType
  ${exist_enquiry_period}=  Run Keyword And Return Status  Dictionary Should Contain Key   ${tender_data.data}   enquiryPeriod
  Run Keyword If  '${procurementMethodType}' not in ['competitiveDialogueEU', 'competitiveDialogueUA', 'defense', 'aboveThresholdEU', 'aboveThresholdUA', 'closeFrameworkAgreementUA', 'esco', 'reporting'] and ${exist_enquiry_period}  Edit Feasible Element  ${tender_data.data.enquiryPeriod}  endDate  Set Date Time  ${locator.enquiry_end_date}
  Run Keyword If  '${procurementMethodType}' not in ['competitiveDialogueEU', 'competitiveDialogueUA', 'defense', 'aboveThresholdEU', 'aboveThresholdUA', 'closeFrameworkAgreementUA', 'esco', 'reporting'] and ${exist_enquiry_period}  Edit Feasible Element  ${tender_data.data.tenderPeriod}  startDate  Set Date Time  ${locator.tender_start_date}
  Run Keyword If  '${procurementMethodType}' not in ['reporting']  Edit Feasible Element  ${tender_data.data.tenderPeriod}  endDate  Set Date Time  ${locator.tender_end_date}

Choise Dont Add Document
  Log To Console  [+] Choise Dont Add Document
  # Click to popup download document
  ${locator.button_tender_no_document}=  Set Variable  xpath=//div[@id="no-docs-btn"]
  Wait Until Page Contains Element  ${locator.button_tender_no_document}  40
  # Wait Until Element Is Visible  ${locator.button_tender_no_document}
  Click Element  ${locator.button_tender_no_document}

Set Created Tender ID In Global Variable
  CustomLog  [+] Set Created Tender ID In Global Variable
  # Get Idsg
  Wait Until Page Contains Element   xpath=//span[@ng-if="tender.tenderID"]
  ${tender_uaid}=  Get Text   xpath=//span[@ng-if="tender.tenderID"]
  ${tender_global}=  Convert To String  ${tender_uaid}
  Set Global Variable  ${g_data.current_tender_id}  ${tender_global}

  [Return]  ${tender_global}


Publish tender
  CustomLog  [+] Publish tender
  # Save tender
  Wait And CLick  xpath=//button[@ng-click="publish()"]
  Capture Page Screenshot
  Sleep  5
  Capture Page Screenshot
  Sleep  5
  Capture Page Screenshot
  Sleep  5
  Capture Page Screenshot

Змінити в тендері поле tenderPeriod.endDate і зберегти
  [Arguments]  ${date}
  Log To Console  [+] Change tender end date: ${date}
  Sleep  2
  Set Date Time  xpath=//input[@id="input-date-tender-tenderPeriod-endDate"]  ${date}
  Sleep  2
  ${api_date}=  api_get_tenderPeriod_end_date  ${data.tender_internal_id}
  Set To Dictionary  ${USERS.users['Newtend_Owner'].tender_data.data.tenderPeriod}  endDate=${api_date}
  Log To Console  ${USERS.users['Newtend_Owner'].tender_data.data.tenderPeriod}
  [Return]  ${date}

Змінити в тендері поле description і зберегти
  [Arguments]  ${description}
  Log To Console  [+] Change tender description: ${description}
  Wait Until Page Contains Element  id=tender-title     20
  Input text   ${locator.edit.description}   ${description}

Edit Criteria
  [Arguments]  ${tender_data}
  [Documentation]
  ...  criteria:
  ...  -   classification:
  ...        id: CRITERION.OTHER.BID.GUARANTEE
  ...        scheme: ESPD211
  ...    legislation:
  ...    -   identifier:
  ...            id: 922-VIII
  ...            legalName: Закон України "Про публічні закупівлі"
  ...            uri: https://zakon.rada.gov.ua/laws/show/922-19
  ...        type: NATIONAL_LEGISLATION
  ...        version: '2020-04-19'
  ...    relatesTo: tender
  ...    requirementGroups:
  ...    -   description: Учасник підтверджує, що
  ...        requirements:
  ...        -   dataType: boolean
  ...            description: 'Умови забезпечення тендерної пропозиції: строк дії забезпечення
  ...                тендерної пропозиції повинен бути протягом строку дії тендерної пропозиції,
  ...                не менше ніж 90 днів з дати розкриття тендерних пропозицій електронною
  ...                системою закупівель (відповідно до ст. 253 Цивільного кодексу України
  ...                розраховується з наступного дня після розкриття тендерних пропозицій
  ...                електронною системою закупівель), вид банківська гарантія'
  ...            eligibleEvidences:
  ...            -   description: документ що підтверджує банківську гарантію
  ...                title: Підтвердження банківської гарантії
  ...                type: document
  ...            expectedValue: 'true'
  ...            title: Вид та умови надання забезпечення тендерних пропозицій
  ...    source: tenderer
  ...    title: Вид та умови надання забезпечення тендерних пропозицій
  ...  - classification:
  ...         id: CRITERION.OTHER.CONTRACT.GUARANTEE
  ...        scheme: ESPD211
  ...    legislation:
  ...    -   article: 14.2.12
  ...        identifier:
  ...            id: 922-VIII
  ...            legalName: Закон України "Про публічні закупівлі"
  ...            uri: https://zakon.rada.gov.ua/laws/show/922-19
  ...        type: NATIONAL_LEGISLATION
  ...        version: '2020-04-19'
  ...    relatesTo: tender
  ...    requirementGroups:
  ...    -   description: Учасник підтверджує, що
  ...        requirements:
  ...        -   dataType: boolean
  ...            description: 'Умови забезпечення виконання умов договору: строк дії забезпечення
  ...                тендерної пропозиції повинен бути протягом строку дії тендерної пропозиції,
  ...                не менше ніж 90 днів з дати розкриття тендерних пропозицій електронною
  ...                системою закупівель (відповідно до ст. 253 Цивільного кодексу України
  ...                розраховується з наступного дня після розкриття тендерних пропозицій
  ...                електронною системою закупівель), вид забезпечення банківська гарантія,
  ...                розмір забезпечення 5% від вартості договору'
  ...            eligibleEvidences:
  ...            -   description: Різнокольоровий скан у форматі pdf
  ...                title: Підтвердження банківської гарантії
  ...                type: document
  ...            expectedValue: 'true'
  ...            title: розмір та умови надання забезпечення виконання договору про закупівлю
  ...    source: winner
  ...    title: Розмір та умови надання забезпечення виконання договору

  CustomLog  [+] Edit Criteria

  ${procurementMethodType}=  Get From Dictionary   ${tender_data.data}   procurementMethodType
  ${criteria_items_data}=  Get From Dictionary  ${tender_data.data}  criteria
  ${criteria_count}=  Get Length  ${criteria_items_data}
  #${exist_before}=  Run Keyword If  '${procurementMethodType}' == 'belowThreshold'  Set Variable  1
  ${exist_before}=  Run Keyword If  '${procurementMethodType}' == 'belowThreshold'  Set Variable  0
  ...  ELSE  Set Variable  10


  : FOR   ${item}  IN RANGE  ${criteria_count}
  \  Log To Console  [+] Create Item '${item}'
  \  ${number_id}=  Evaluate  ${item}+${exist_before}
  \  ${number_id}=  Convert To Integer  ${number_id}
  \  #Log To Console  Number criteria: '${number_id}'
  \
  \  # add criteria
  \  # ====== choise type ======
  \  ${criteria_type}=  Get From Dictionary  ${tender_data.data.criteria[${item}].classification}  id
  \  Run Keyword If  '${criteria_type}' == 'CRITERION.OTHER.BID.GUARANTEE'  Wait And Click  ${locator.criteria_add_criteria_to_tender}
  \  Run Keyword If  '${criteria_type}' == 'CRITERION.OTHER.CONTRACT.GUARANTEE'  Wait And Click  ${locator.criteria_add_criteria_to_agreement}
  \  # ====== end choise type ======
  \
  \  # ====== open form ======
  \  Sleep  2
  \  ${criteria_items}=  Get WebElements  ${locator.criteria_items}
  \  ${criteria_element_count}=  Get Length  ${criteria_items}
  \  #Log To Console  Element Criteria on page ${criteria_element_count}
  \  Wait And CLick  ${criteria_items[${number_id}]}
  \  # ====== open form ======
  \
  \  # === select related to ==========
  \  # obj name="relatedItem_0"
  \  Sleep   2
  \  ${locator.select_criteria_relatesTo}=  Set Variable  xpath=//md-select[@name="relatedItem_${item}"]
  \  If Exist Locator Click  ${locator.select_criteria_relatesTo}
  \  # obj ng-value="lot.id"
  \  ${locator.option_citeria_related_to_tender}=  Set Variable  xpath=//md-option[@ng-value="lot.id"]
  \  #  \  If Exist Locator Click  ${locator.option_citeria_related_to_tender}
  \  ${locator_exist}=  Run Keyword And Return Status  Get WebElements  ${locator.option_citeria_related_to_tender}
  \  ${obj}=  Run Keyword If  ${locator_exist}  Get WebElements  ${locator.option_citeria_related_to_tender}
  \  Run Keyword If  ${locator_exist}  Focus  ${obj[-1]}
  \  Run Keyword If  ${locator_exist}  Sleep  1
  \  Run Keyword If  ${locator_exist}  Click Element  ${obj[-1]}
  \  Run Keyword If  ${locator_exist}  Sleep  2
  \  #If Exist Locator Click  ${locator.option_citeria_related_to_tender}
  \  # === end select related to ==========
  \
  \  # criteria description
  \  ${criteria_description}=  Get From Dictionary  ${criteria_items_data[${item}].requirementGroups[0].requirements[0]}   description
  \  Wait And Type  id=requirement_description_${number_id}_0_0   ${criteria_description}
  \
  \  # add evidence
  \  Wait And Click  id=addEligibleEvidence_${number_id}_0_0
  \
  \  # edit data about criteria evidence
  \  ${evidence_item}=   Get From Dictionary  ${criteria_items_data[${item}].requirementGroups[0].requirements[0]}  eligibleEvidences
  \
  \  ${evidence_title}=        Get From Dictionary  ${evidence_item[0]}   title
  \  ${evidence_description}=  Get From Dictionary  ${evidence_item[0]}   description
  \  ${evidence_type}=         Get From Dictionary  ${evidence_item[0]}   type
  \
  \  # choisce rudio button
  \  #Run Keyword If  '${evidence_type}' == 'document'  Click Element  ${locator.criteria_evidence_type_doc}
  \  #Run Keyword If  '${evidence_type}' == 'statement'  Click Element  ${locator.criteria_evidence_type_statement}
  \
  \  Wait And Type  id=criteria_title_${number_id}_0_0_0  ${evidence_title}
  \  Wait And Type  id=criteria_description_${number_id}_0_0_0  ${evidence_description}

Edit Guarentee
  [Arguments]  ${tender_data}
  CustomLog  [+] Edit Guarentee

  ${guarantee_amount}=  Get From Dictionary  ${tender_data.data.guarantee}  amount
  ${guarantee_amount}=  convert_budget  ${guarantee_amount}
  ${guarantee_currency}=  Get From Dictionary  ${tender_data.data.guarantee}  currency

  # tender with guarantee
  Focus  ${locator.edit_guarantee_dropdown_menu}
  Select From List By Index  ${locator.edit_guarantee_dropdown_menu}  1

  Wait And Type  ${locator.edit_guarantee_amount}  ${guarantee_amount}
  Select From List By Label  ${locator.edit_guarantee_currency}  ${guarantee_currency}

Edit Guarentee In Lot
  [Arguments]  ${tender_data}
  CustomLog  [+] Edit Guarentee In Lot
  ${locator.edit_guarantee_dropdown_menu_lot}=  Set Variable  xpath=//select[@ng-model="guarantee"]
  ${locator.edit_guarantee_amount_lot}=  Set Variable  xpath=//input[@ng-model="lot.guarantee.amount"]
  ${locator.edit_guarantee_currency_lot}=  Set Variable  xpath=//select[@ng-model="lot.guarantee.currency"]

  ${guarantee_amount}=  Get From Dictionary  ${tender_data.data.guarantee}  amount
  ${guarantee_amount}=  convert_budget  ${guarantee_amount}
  ${guarantee_currency}=  Get From Dictionary  ${tender_data.data.guarantee}  currency

  # tender with guarantee
  Focus  ${locator.edit_guarantee_dropdown_menu_lot}
  Select From List By Index  ${locator.edit_guarantee_dropdown_menu_lot}  1

  Wait And Type  ${locator.edit_guarantee_amount_lot}  ${guarantee_amount}
  Select From List By Label  ${locator.edit_guarantee_currency_lot}  ${guarantee_currency}


Input Custom Date
  [Arguments]  ${tender_data}
  Log To Console  [.] Changing Date Data In Tender
  # change tender data
  
  # get page url
  ${now_url}=  Get Location
  Log To Console  Browser Location: ${now_url}

  # if it's tender get hash_id
  ${tender_hash_id}=  Get Substring  ${now_url}  46  -9
  Log To Console  Hash: ${tender_hash_id}

  # go to edit
  ${url_tender_edit}=  Set Variable   ${HOST}/opc/provider/tender/${tender_hash_id}/edit
  Go To  ${url_tender_edit}

  # change date
  Edit Date For Tender  ${tender_data}

  # save
  Publish tender

  [Return]  ${tender_data}

Edit MainProcurementCategory
  [Arguments]  ${tender_data}
  CustomLog  [+] Edit MainProcurementCategory

  ${locator.mainProcurementCategory}=  Set Variable  xpath=//select[@id="mainProcurementCategory"]
  Edit Feasible Element  ${tender_data.data}   mainProcurementCategory  Select From List By Value  ${locator.mainProcurementCategory}

Edit Supplement Criteria
  [Arguments]  ${tender_data}
  [Documentation]
  ...  criteria:
  ...  - data-criteria_id="bdff7978ae53d4dc29e25d0d063da52b"
  ...  -- data-requirement_group_id="4a1ef67cc9134fa2968f252b2c62deda"
  ...  --- data-requirement_id="f3dce577eee44bfc8c4f1cdb3535c811"

  Log To Console  [+] Collect data about criteria
  
  Sleep  3

  ${locator.criterias}=  Set Variable  xpath=//div[@ng-if="tender.criteria"]/div
  ${procurementMethodType}=  Get From Dictionary  ${tender_data.data}  procurementMethodType

  ${criteria_from_data}=  Get From Dictionary    ${tender_data.data}  criteria
  ${count_of_criteria}=  Get Length  ${criteria_from_data}
  ${exist_before}=  Convert To Integer  0
  Run Keyword If  '${procurementMethodType}' in ['aboveThresholdEU', 'aboveThresholdUA']  ${exist_before}=  Convert To Integer  10

  : FOR   ${item}   IN RANGE    ${count_of_criteria}
  \  ${numb}=  Evaluate  ${item}+${exist_before}
  \  ${numb}=  Convert To Integer ${numb}
  \  # get criteria id
  \  ${data.criteria_id}=  Get Element Attribute  xpath=//div[@ng-if="tender.criteria"]/div[${numb}]@data-criteria_id
  \  ${data.requirement_group_id}=  Get Element Attribute  xpath=//div[@ng-if="tender.criteria"]/div[${numb}]/div[3]@data-requirement_group_id
  \  ${data.requirement_id}=  Get Element Attribute  xpath=//div[@ng-if="tender.criteria"]/div[${numb}]/div[3]/div[1]@data-requirement_id
  \  ${data.eligible_evidence_id}=  Get Element Attribute  xpath=//div[@ng-if="tender.criteria"]/div[${numb}]/div[3]/div/div@data-eligible_evidence_id
  \
  \  Log To Console  criteria_id: ${data.criteria_id}
  \  Log To Console  requirement_group_id: ${data.requirement_group_id}
  \  Log To Console  requirement_id: ${data.requirement_id}
  \  Log To Console  eligible_evidence_id: ${data.eligible_evidence_id}
  \
  \  # put inside dict
  \  Set To Dictionary  ${tender_data.data.criteria[${item}]}  id=${data.criteria_id}
  \  Set To Dictionary  ${tender_data.data.criteria[${item}].requirementGroups[0]}  id=${data.requirement_group_id}
  \  Set To Dictionary  ${tender_data.data.criteria[${item}].requirementGroups[0].requirements[0]}  id=${data.requirement_id}
  \  Set To Dictionary  ${tender_data.data.criteria[${item}].requirementGroups[0].requirements[0].eligibleEvidences[0]}  id=${data.requirement_id}

  Set Global Variable  ${g_tender_data}  ${tender_data}

Edit Supplement Criteria New
  [Arguments]  ${tender_data}
  CustomLog  [+] Collect Criteria

  # storage criterias
  ${storage_criteria}=  create_empty_list

  Sleep  3
  # define count of criterias
  ${locator.criterias}=  Set Variable  xpath=//div[@ng-if="tender.criteria"]/div
  ${elements_criteria}=  Get WebElements  ${locator.criterias}
  ${count_of_criteria}=  Get Length  ${elements_criteria}
  Log To Console  [_] Count criteria ${count_of_criteria}
  ${exist_before}=  Convert To Integer  0

  : FOR   ${item}   IN RANGE  ${count_of_criteria}
  \  ${numb}=  Evaluate  ${item}+${exist_before}
  \  ${numb}=  Convert To Integer  ${numb}
  \  Log To Console  [_] Collect criteria ${numb}
  \  ${critetia_element_path}=  Set Variable  xpath=//div[@data-count_number="${numb}"]
  \  ${criteria_data}=  Get Element Attribute  ${critetia_element_path}@data-criteria
  \  #Log To Console  Find criteria ${criteria_data}
  \  ${clean_data}=  convert_string_in_json  ${criteria_data}
  \  # Set List Value  ${storage_criteria}  0  ${clean_data}
  \  Append To List  ${storage_criteria}  ${clean_data}

  Set To Dictionary  ${tender_data.data}  criteria=${storage_criteria}

  [Return]   ${tender_data}

Make Global Variable
  [Arguments]  ${username}  ${tender_data}
  Log To Console  [+] Make Global Variable
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender_data}

Get Tender Internal Id
  # return internal id
  # https://autotest.newtend.com/opc/provider/tender/1195c9cda3fd45f6b5afd2df85aa044b/overview
  Log To Console  [+] Get Tender Internal Id
  ${now_url}=  Get Location
  ${result}=  Get Substring  ${now_url}  -41  -9
  Set Global Variable  ${data.tender_internal_id}  ${result}
  Log To Console  [+] Get Tender Internal Id: ${result}
  [return]  ${result}

Return Tender Obj
  [Arguments]  ${tender_internal_id}
  Log To Console  [+] Get Tender Data From Api
  ${result}=  newtend_get_tender  ${tender_internal_id}
  [return]  ${result}

Put Tender In Global Verable
  [Arguments]  ${username}
  Log To Console  [+] Put Tender data in Global Veriable
  ${internal_id}=  Get Tender Internal Id
  ${raw_tender_data}=  Return Tender Obj  ${internal_id}
  ${tender_data}=  Get From Dictionary  ${raw_tender_data}  data
  #Log To Console  ${tender_data}
  ${convert_tender_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${tender_data}
  Set To Dictionary  ${USERS.users['${username}'].tender_data}   data=${convert_tender_data}
  #Set To Dictionary  ${USERS.users['${username}'].initial_data}   data=${convert_tender_data}
  #Set To Dictionary  ${USERS.users['${username}'].initial_data}  tender_data=${raw_tender_data}
  #Set Global Variable  ${USERS.users['${username}'].data}  ${tender_data}
  Log To Console  [+] Put Tender Data Api In Storage

Edit NDS
  [Arguments]  @{ARGS}
  Log To Console  [+] Edit Tender NDS
  ${tender_data}=  Set Variable  ${ARGS[0]}
  Log To Console  [*] Click to button with NDS
  ${lot_nds}=  Set Variable  ${tender_data.data.lots[0].value.valueAddedTaxIncluded}
  Run Keyword If  '${lot_nds}' == 'True'  Focus  xpath=//input[@id="with-nds"]
  Run Keyword If  '${lot_nds}' == 'True'  Select Checkbox  xpath=//input[@id="with-nds"]


Edit NDS Negotiation
  [Arguments]  @{ARGS}
  Log To Console  [+] Edit Tender NDS Negotiation
  ${tender_data}=  Set Variable  ${ARGS[0]}
  Log To Console  [*] Click to button with NDS
  ${lot_nds}=  Set Variable  ${tender_data.data.value.valueAddedTaxIncluded}
  Run Keyword If  '${lot_nds}' == 'True'  Focus  xpath=//input[@id="with-nds"]
  Run Keyword If  '${lot_nds}' == 'True'  Select Checkbox  xpath=//input[@id="with-nds"]


Change Time In Two Stage
  ${date_time_plus_10_min}=  date_now_plus_minutes  31
  ${hour}=  Get Substring  ${date_time_plus_10_min}  11  13
  ${min}=  Get Substring  ${date_time_plus_10_min}  14  16
  Log To Console  [ ] Hour ${hour} | Min: ${min}

  Focus  xpath=//input[@ng-change="updateHours()"]
  Wait And Type  xpath=//input[@ng-change="updateHours()"]  ${hour}
  Wait And Type  xpath=//input[@ng-change="updateMinutes()"]  ${min}


Add Criteria To Second Stage

  Log To Console  [.] Go To Edit Tender
  # edit tender
  Wait And Click  xpath=//a[@id="edit-tender-btn"]
  Sleep  5
  Log To Console  [+] Go To Edit Tender
  Capture Page Screenshot

  Log To Console  [.] Change Time
  # === change time ===
  Change Time In Two Stage
  Capture Page Screenshot
  Log To Console  [+] Change Time

  # === publish ===
  Log To Console  [.] Save Tender 2 stage
  Wait And Click  xpath=//button[@ng-click="publish()"]
  Sleep  5
  Capture Page Screenshot
  Sleep  5
  Capture Page Screenshot
  Log To Console  [+] Save Tender 2 stage


