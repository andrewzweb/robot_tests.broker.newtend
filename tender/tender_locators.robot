*** Variables ***

${url.tender_single_lot}    https://autotest.newtend.com/opc/provider/create-tender/singlelot/belowThreshold/tender/
${url.tender_reporting}     https://autotest.newtend.com/opc/provider/create-tender/singlelot/reporting/tender/
${url.tender_negotiation}   https://autotest.newtend.com/opc/provider/create-tender/singlelot/negotiation/tender/
${url.tender_multilots}     https://autotest.newtend.com/opc/provider/create-tender/multilot/belowThreshold/tender/

${locator.button_publish}                  xpath=//button[@ng-click="publish()"]
${locator.lot_title_eng}                   xpath=//input[@id="lot_title_eng_0"]
${locator.button_create_tender_from_plan}  xpath=//button[@ng-click="createTenderFromPlan()"]

${locator.tender_some_locator}    xpath=//input[@ng-model="searchData.query"]

${locator.view_item_description}    xpath=//div[@id="view-item-description"]

# tender title
${locator.edit_tender_title}            xpath=//input[@id="tender-title"]
${locator.edit_tender_title_en}         xpath=//input[@id="tender-title-en"]
${locator.edit_tender_description}      xpath=//textarea[@id="tender-description"]
${locator.edit_tender_description_en}   xpath=//textarea[@id="tender-description-en"]

# tender date
${locator.enquiry_end_date}                 xpath=//input[@id="input-date-tender-enquiryPeriod-endDate"]
${locator.tender_start_date}            xpath=//input[@id="input-date-tender-tenderPeriod-startDate"]
${locator.tender_end_date}              xpath=//input[@id="input-date-tender-tenderPeriod-endDate"]

# tender items
${locator.edit_item_title_en}   id=itemTitle-en
${locator.edit_item_description_en}   id=itemDescription-en

# tender cause
${locator.edit_tender_cause_title}          xpath=//input[@id="tender-cause-description"]
${locator.edit_tender_cause_desctiption}    xpath=//select[@ng-model="tender.cause"]

# tender agreement
${locator.edit_argeement_duration_year}     xpath=//input[@id="tender-duration-year"]
${locator.edit_argeement_duration_mounth}   xpath=//input[@id="tender-duration-month"]
${locator.edit_argeement_duration_day}      xpath=//input[@id="tender-duration-days"]
${locator.edit_argeement_max_count}             xpath=//input[@id="tender-people-amount"]

# Lot view
${locator.view_lot_accordeon}  xpath=//h2[@class="tender-block__title tender-block__title--bold ng-binding ng-scope"]

${locator.view_lots[0].title}                              xpath=//div[@id="view_lot_title_0"]
${locator.view_lots[0].description}                        xpath=//div[@id="view_lot_description_0"]
${locator.view_lots[0].value.amount}                       xpath=//span[@id="view_lot_value_amount_0"]
${locator.view_lots[0].value.currency}                     xpath=//span[@id="view_lot_value_currency_0"].
${locator.view_lots[0].value.valueAddedTaxIncluded}        xpath=//span[@id="view_lot_value_valueAddedTaxIncluded_0"]
${locator.view_lots[0].minimalStep.amount}                 xpath=//span[@id="view_lot_minimalStep_amount_0"]
${locator.view_lots[0].minimalStep.currency}               xpath=//span[@id="view_lot_minimalStep_currency_0"]
${locator.view_lots[0].minimalStep.valueAddedTaxIncluded}  xpath=//span[@id="view_lot_minimalStep_valueAddedTaxIncluded_0"]

# Lot edit
${locator.edit_lot_title}                   xpath=//input[@ng-model="lot.title"]
${locator.edit_lot_title_en}                xpath=//input[@ng-model="lot.title_en"]
${locator.edit_lot_description}             xpath=//input[@ng-model="lot.description"]
${locator.edit_lot_description_en}          xpath=//input[@ng-model="lot.description_en"]
${locator.edit_lot_amount}                  xpath=//input[@ng-model="lot.value.amount"]
${locator.edit_lot_step}                    xpath=//input[@ng-model="lot.minimalStep.amount"]
${locator.edit_lot_minimalStepPercentage}   xpath=//input[@ng-model="lot.minimalStepPercentage"]
${locator.edit_lot_save_form}               xpath=//button[@ng-click="addLot()"]
${locator.edit_lot_yearlyPaymentsPercentageRange}   xpath=//input[@ng-model="lot.yearlyPaymentsPercentageRange"]

# Funders
${locator.view_funders[0].name}                            xpath=//div[@id="funder_identifier_legal_name"]
${locator.view_funders[0].address.countryName}             xpath=//span[@id="funder_address_country_name"]
${locator.view_funders[0].address.locality}                xpath=//span[@id="funder_address_locality"]
${locator.view_funders[0].address.postalCode}              xpath=//span[@id="funder_address_postal_code"]
${locator.view_funders[0].address.region}                  xpath=//span[@id="funder_address_region"]
${locator.view_funders[0].address.streetAddress}           xpath=//span[@id="funder_address_street_address"]
${locator.view_funders[0].identifier.id}                   xpath=//span[@id="funder_identifier_id"]
${locator.view_funders[0].identifier.legalName}            xpath=//div[@id="funder_identifier_legal_name"]
${locator.view_funders[0].identifier.scheme}               xpath=//span[@id="funder_identifier_scheme"]

# singup
${locator.singup_tender_button_form}  xpath=//button[@ng-click="sign()"] 
${locator.singup_plan_button_form}  xpath=//button[@id="sign-tender-btn"]
${locator.singup_frame}  xpath=//iframe[@id="sign-widget"]
${locator.singup_upload_key_file}  xpath=//input[@id="pkReadFileTextField"]
${locator.singup_upload_key_file_input}  xpath=//input[@id="pkReadFileInput"]
${locator.singup_pass_to_key}  xpath=//input[@id="pkReadFilePasswordTextField"]
${locator.singup_button_to_read_data}  xpath=//div[@id="pkReadFileButton"]
${locator.singup_button_go_ahead}  xpath=//div[@id="pkInfoNextButton"]
${locator.singup_button_singup_tender}  xpath=//div[@class="modal-content"]//button[@ng-click="vm.sign()"]

# search tender
${page_search_tender}  https://autotest.newtend.com/opc/provider/home/
${locator.tender_search_input_field}  xpath=//input[@ng-model="searchData.query"]
${locator.tender_search_button}  xpath=//button[@ng-click="search()"]

# milestone
${locator.view_milestone[0].title}           xpath=//div[@id="milestone_title_0"]
${locator.view_milestone[0].code}            xpath=//div[@id="milestone_code_0"]
${locator.view_milestone[0].percentage}      xpath=//div[@id="milestone_percentage_0"]
${locator.view_milestone[0].duration_type}   xpath=//span[@id="milestone_duration_type_0"]
${locator.view_milestone[0].duration_days}   xpath=//span[@id="milestone_duration_days_0"]

${locator.view_milestone[1].title}           xpath=//div[@id="milestone_title_1"]
${locator.view_milestone[1].code}            xpath=//div[@id="milestone_code_1"]
${locator.view_milestone[1].percentage}      xpath=//div[@id="milestone_percentage_1"]
${locator.view_milestone[1].duration_type}   xpath=//span[@id="milestone_duration_type_1"]
${locator.view_milestone[1].duration_days}   xpath=//span[@id="milestone_duration_days_1"]

${locator.view_milestone[2].title}           xpath=//div[@id="milestone_title_2"]
${locator.view_milestone[2].code}            xpath=//div[@id="milestone_code_2"]
${locator.view_milestone[2].percentage}      xpath=//div[@id="milestone_percentage_2"]
${locator.view_milestone[2].duration_type}   xpath=//span[@id="milestone_duration_type_2"]
${locator.view_milestone[2].duration_days}   xpath=//span[@id="milestone_duration_days_2"]

# features
${locator.edit_feature_add_button}      xpath=//input[@id="qualityIndicator"]
${locator.edit_feature_add_form}        xpath=//ng-form[@name="qualityForm"]/div/h3
${locator.edit_feature_save_form}       xpath=//button[@ng-click="save()"]

${locator.edit_feature_add_enum}        id=add-option-0
${locator.edit_feature_title}           xpath=//div[@class="item ng-scope"]//input[@name="title0"]
${locator.edit_feature_title_en}        xpath=//div[@class="item ng-scope"]//input[@name="title_en0"]
${locator.edit_feature_description}     xpath=//div[@class="item ng-scope"]//input[@name="description0"]
${locator.edit_feature_description_en}  xpath=//div[@class="item ng-scope"]//input[@name="description_en0"]
${locator.edit_feature_relation_of}     xpath=//select[@ng-model="item.featureOf"]

${locator.edit_feature_add_enum}        xpath=//a[@ng-click="addField($parent.$index)"]

${locator.edit_feature_enum_title_0}    xpath=//input[@name="option0" and @ng-model="option.title"]
${locator.edit_feature_enum_value_0}    id=optionWeight0
${locator.edit_feature_enum_descr_0}    id=optionDescription0

${locator.edit_feature_enum_title_1}    xpath=//input[@name="option1" and @ng-model="option.title"]
${locator.edit_feature_enum_value_1}    id=optionWeight1
${locator.edit_feature_enum_descr_1}    id=optionDescription1

${locator.edit_feature_enum_title_2}    xpath=//input[@name="option2" and @ng-model="option.title"]
${locator.edit_feature_enum_value_2}    id=optionWeight2
${locator.edit_feature_enum_descr_2}    id=optionDescription2

# guarentee
${locator.edit_guarantee_dropdown_menu}  xpath=//select[@id="guarantee"]
${locator.edit_guarantee_amount}         xpath=//input[@id="guarantee-amount"]
${locator.edit_guarantee_currency}       xpath=//select[@id="guarantee-currency"]

# criteria
${locator.criteria_add_criteria_to_tender}     xpath=//button[@ng-click="addGuaranteeCriteria()"]
${locator.criteria_add_criteria_to_agreement}  xpath=//button[@ng-click="addContractGuaranteeCriteria()"]
${locator.criteria_add_evidence}               xpath=//button[@ng-click="addEligibleEvidence(requirement)"]
${locator.criteria_items}                      xpath=//h4[@class="title ng-binding"]
${locator.edit_criteria_description}           xpath=//textarea[@ng-model="requirement.description"]

${locator.criteria_evidence_type_doc}          xpath=//md-radio-button[@value="document"]
${locator.criteria_evidence_type_statement}    xpath=//md-radio-button[@value="statement"]

${locator.criteria_evidence_title}             xpath=//input[@ng-model="eligibleEvidence.title"]
${locator.criteria_evidence_description}       xpath=//textarea[@ng-model="eligibleEvidence.description"]


${locator.edit_esco_NBUdiscountRate}                xpath=//input[@id="NBUdiscountRate"]
${locator.edit_esco_fundingKind}                    xpath=//select[@id="fundingKind"]
