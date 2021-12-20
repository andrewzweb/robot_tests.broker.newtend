** Settings ***
Resource  ./tender_edit/tender_edit_base.robot
Resource  ./tender_edit/tender_edit_bid.robot
Resource  ./tender_edit/tender_edit_lot.robot
Resource  ./tender_edit/tender_edit_item.robot
Resource  ./tender_edit/tender_edit_qualification.robot

*** Keywords ***

Edit Milestones
  [Arguments]  ${tender_data}

  ${milestones_list}=   Get From Dictionary     ${tender_data.data}   milestones
  ${NUMBER_OF_MILESTONES}=  Get Length  ${milestones_list}

  : FOR   ${I}   IN RANGE    ${NUMBER_OF_MILESTONES}
  \   ${milestoneCode}=         Get From Dictionary     ${milestones_list[${I}]}    code
  \   ${milestoneDuration}=     Get From Dictionary     ${milestones_list[${I}]}    duration
  \   ${milestoneDurDays}=      Get From Dictionary     ${milestoneDuration}     days
  \   ${milestoneDurType}=      Get From Dictionary     ${milestoneDuration}     type
  \   ${milestonePercentage}=   Get From Dictionary     ${milestones_list[${I}]}    percentage
  \   ${milestoneSequence}=     Get From Dictionary     ${milestones_list[${I}]}    sequenceNumber
  \   ${milestoneTitle}=        Get From Dictionary     ${milestones_list[${I}]}    title
  \   ${milestoneType}=         Get From Dictionary     ${milestones_list[${I}]}    type
  \   Sleep  2
  \   Execute Javascript    window.document.getElementById('button_add_payment_terms').click()
  \
  \   Wait Until Page Contains Element  id=milestone-title-${I}
  \   Focus  id=milestone-title-${I}
  \   Select From List By Value   xpath=//select[@id="milestone-title-${I}"]    ${milestoneTitle}
  \   Select From List By Value   xpath=//select[@id="milestone-code-${I}"]     ${milestoneCode}
  \   Wait And Type    id=milestone-duration-days-${I}     ${milestoneDurDays}
  \   Select From List By Value   xpath=//select[@id="milestone-duration-type-${I}"]   ${milestoneDurType}
  \   Wait And Type    id=milestone-percentage-days-${I}   ${milestonePercentage}
  \   Wait And Type    id=milestone-description-${I}       ${milestoneType}


Edit Funders
  [Arguments]  ${tender_data}
  ${locator.funder_select_field}=  Set Variable  xpath=//select[@id="funder"]
  Focus  ${locator.funder_select_field}
  Select From List By Label  ${locator.funder_select_field}  ${tender_data.data.funders[0].identifier.legalName}

Add Funders
  [Arguments]  @{tender_data}
  Log To Console  ${tender_data}

Delete Funders
  [Arguments]  @{tender_data}
  Log To Console  ${tender_data}

# :TODO MEATS add
Add meats to tender
  [Arguments]  ${tender_data}

  Wait And Click   id=qualityIndicator


  : FOR   ${INDEX}  IN RANGE   ${TENDER_MEAT}
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


Find Tender By Id
  [Arguments]  ${tender_id}  ${username}=None
  Log To Console  [+] Find Tender id: ${tender_id} | username: '${username}'

  Sync Tender

  Sleep  3
  ${browser_on_page}=  Run Keyword And Return Status  Get WebElement  xpath=//a[@class="ng-binding ng-scope"]
  Log To Console  [${browser_on_page}] On page tendera?
  #${tender_id_on_page}=  Run Keyword If  ${browser_on_page}  Get Text  xpath//a[@class="ng-binding ng-scope"]
  #${correct_page}=  is_one_string_include_other_string  ${tender_id_on_page}  ${tender_id}
  Run Keyword If  '${browser_on_page}' == 'False'  Action Get Tender  ${tender_id}
  Run Keyword If  '${browser_on_page}' == 'True'  Go To Overview

  #Action Get Tender  ${tender_id}
  Save For Global  ${username}

Action Get Tender
  [Arguments]  ${tender_id}
  Log To Console  [+] search tender
  Go To  ${page_search_tender}
  Wait And Type  ${locator.tender_search_input_field}  ${tender_id}
  Wait And Click  ${locator.tender_search_button}
  Sleep  3

  Wait Until Keyword Succeeds  8 minute  15 seconds  Try Choice Tender From Search List  ${tender_id}

Try Choice Tender From Search List
  [Arguments]  ${tender_id}
  Reload Page
  ${data.tender_id}=  Set Variable  Convert To String  ${tender_id}
  ${locator.link_to_tender}=  Set Variable  xpath=//a[@class="title ng-binding"]

  ${can_click}=  Run Keyword And Return Status  Wait Until Element Is Visible  ${locator.link_to_tender}  20
  Wait And Click  ${locator.link_to_tender}
  Run Keyword If  '${can_click}' == False  Log To Console  [-] Can't see tender in search wait..
  Run Keyword If  '${can_click}' == True   Log To Console  [+] See tender in search and click
  Sleep  5
  [Return]  ${can_click}

Save For Global
  [Arguments]  ${username}=None
  # try to fix error cant find data for competitive
  Run Keyword If  '${username}' != 'None'  Log To Console  [+] Username True
  ${tender_data}=  Run Keyword If  '${username}' != 'None'  newtend_get_tender  ${data.tender_internal_id}
  ${tender_data}=  Run Keyword If  '${username}' != 'None'  op_robot_tests.tests_files.service_keywords.Munchify  ${tender_data}
  Run Keyword If  '${username}' != 'None'  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender_data}

Sync Tender
  ${status}=  Run Keyword And Return Status  api_sync_tender  ${data.tender_internal_id}
  Log To Console  [${status}] Sync tender id: ${data.tender_internal_id}

Sync Contract
  ${status}=  Run Keyword And Return Status  api_sync_contract  ${data.contract_internal_id}
  Log To Console  [${status}] Sync contract id: ${data.contract_internal_id}

################################################################
#                                                              #
#             Start Получить тендерную информацию              #
#                                                              #
################################################################
  
################################################################
#                                                              #
#             End Получить тендерную информацию                #
#                                                              #
################################################################

################################################################
#                                                              #
#             Изменить информацию о тендере                    #
#                                                              #
################################################################

Set DKPP
  [Arguments]   ${add_classification_id}   ${INDEX}   ${add_classification_scheme}
  Sleep     2
  Focus                 xpath=//input[contains(@id, 'deliveryAddress-${INDEX}')]
  #Log To Console    Scheme type - ${add_classification_scheme}
  # Medical Instruments and Classification
  ${gmdn_field}=    Run Keyword If    '${add_classification_scheme}' in ['GMDN', 'АТХ', 'UA-ROAD']   Get Webelements    xpath=//tender-classifier[@label="${add_classification_scheme}"]
  Run Keyword If    '${add_classification_scheme}' in ['GMDN', 'АТХ', 'UA-ROAD']   Sleep  1
  Run Keyword If    '${add_classification_scheme}' in ['GMDN', 'АТХ', 'UA-ROAD']   Click Element     ${gmdn_field[-1]}
  Run Keyword If    '${add_classification_scheme}' in ['GMDN', 'АТХ', 'UA-ROAD']   Sleep   2

  # Simple DKPP Selection
  ${dkpp_fields}=   Run Keyword If    '${add_classification_scheme}' not in ['GMDN', 'АТХ', 'UA-ROAD']     Get Webelements   xpath=//input[contains(@id,'classifier-dkpp')]
  Run Keyword If    '${add_classification_scheme}' not in ['GMDN', 'АТХ', 'UA-ROAD']  Click Element     ${dkpp_fields[-1]}
  Run Keyword If    '${add_classification_scheme}' not in ['GMDN', 'АТХ', 'UA-ROAD']  Sleep   2

  Wait Until Page Contains Element  id=classifier-search-field    20
  Wait And Type  id=classifier-search-field  ${add_classification_id}
  Wait Until Page Contains Element    xpath=//span[contains(text(),'${add_classification_id}')]   20
  Sleep     2
  Click Element                      xpath=//input[@ng-change="chooseClassificator(item)"]
  Sleep     1
  Click Element                      id=select-classifier-btn
  Sleep     2

################################################################
#                                                              #
#             End Изменить информацию о тендере                #
#                                                              #
################################################################

Go To Plan And SingUp
  # Get Plan Id 
  ${plan_data}=  load_data_from   artifact_plan.yaml
  Find Plan By UAID  ${plan_data.tender_uaid}
  Sleep  2
  ${status}=  Run Keyword And Return Status  SingUp Plan
  Log To Console  [${status}] SingUp Plan
  # if plan create quinta and give us only id we change flow to execution script
  Run Keyword If  ${status} == False  Plan Get Internal Id  -41  -9
  Run Keyword If  ${status} == False  Go To Create OpenEU
  Sleep  4

  ${locator.button_create_tender_from_plan}=  Set Variable  xpath=//button[@ng-click="createTenderFromPlan()"]
  Run Keyword If  ${status} == True  Wait And Click  ${locator.button_create_tender_from_plan}

Edit Cause
  [Arguments]  ${tender_data}
  [Documentation]  Input data
  ...  cause: resolvingInsolvency
  ...  causeDescription: Докандибити гаріль виголос фльорес галаснути відчалювати збірослов
  ...      попереправляти повиводити поперетоплювати мнишки кантурь слідити.

  ${cause}=  Get From Dictionary  ${tender_data.data}  cause
  ${causeDesctiption}=  Get From Dictionary  ${tender_data.data}  causeDescription
  Wait And Type   xpath=//input[@id="tender-cause-description"]  ${causeDesctiption}
  Select From List By Value  ${locator.edit_tender_cause_desctiption}  ${cause}

Edit Argeement Duration
  [Arguments]  ${tender_data}
  [Documentation]  Input data
  ...  agreementDuration: P2Y8M1D
  ...  maxAwardsCount: 5

  ${data.argeement_duration}=  Get From Dictionary  ${tender_data.data}  agreementDuration

  ${duration_year}=  Get Substring  ${data.argeement_duration}     1   2
  ${duration_mounth}=  Get Substring  ${data.argeement_duration}   3   4
  ${duration_day}=  Get Substring  ${data.argeement_duration}      5   6
  
  Wait And Type  ${locator.edit_argeement_duration_year}    ${duration_year}
  Wait And Type  ${locator.edit_argeement_duration_mounth}  ${duration_mounth}
  Wait And Type  ${locator.edit_argeement_duration_day}     ${duration_day}
  
  ${data.argeement_max_award_count}=  Get From Dictionary  ${tender_data.data}  maxAwardsCount

  Wait And Type  ${locator.edit_argeement_max_count}     ${data.argeement_max_award_count}
