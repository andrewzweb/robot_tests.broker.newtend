*** Settings ***
Library   ../helper/newtend_service.py
Resource  ../newtend.robot
Resource  ../helper/helper.robot
Resource  ../helper/data.robot
Resource  ../tender/tender.robot
Resource  plan_helper.robot
Resource  plan_locators.robot

*** Keywords ***

################################################################
#                                                              #
#             Start Навигация                                  #
#                                                              #
################################################################

Find Plan By UAID
  [Arguments]  ${plan_uaid}
  Log To Console  [+] Find plan by id:
  # go to search plan page 
  Go To  ${page.sarch_plans}
  # wait field search 
  Wait Until Page Contains Element  ${locator.field_search_plan}  20
  # click field search
  Click Element  ${locator.field_search_plan}
  # input our tender id in search field 
  Input Text  ${locator.field_search_plan}  ${plan_uaid}
  # click to search
  Click Element  ${locator.button_search_plan}

  Wait Until Keyword Succeeds  5 minute  30 seconds  Try Choice Plan From Searh List  ${plan_uaid}

  ${plan_hash}=  Get Text  id=view-plan-id
  Set Global Variable  ${data.plan_id_hash}  ${plan_hash}

Try Choice Plan From Searh List
  [Arguments]  ${plan_uaid}
  Log To Console  [.] Try click to search plan

  Reload Page
  # wait results 
  Wait Until Page Contains Element  ${locator.result_plans_list}  20
  # we find plan
  ${locator.link_to_first_plan}=  Set Variable  xpath=//span[contains(text(), '${plan_uaid}')]
  # go to plan
  ${can_click}=  Run Keyword And Return Status  Click Element  ${locator.link_to_first_plan}
  Run Keyword If  '${can_click}' == False  Log To Console  [-] Can't see plan in search wait..
  Run Keyword If  '${can_click}' == True   Log To Console  [+] See plan in search and click
  [Return]  ${can_click}


Знайти и перейти до плану закупівлі
  [Arguments]  ${user}  ${tender_id}  @{data}
  Go To  ${HOST}/opc/provider/plans/all/?pageNum=1&query=${tender_id}&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=
  Wait Until Page Contains Element  xpath=//a[@class="row tender-info ng-scope"]    20
  ${plan_raw}=  Get Webelement  xpath=//span[contains(text(), '${tender_uaid}')]
  Click Element  ${plan_raw}
  Sleep  1

Перейти на сторінку редактування плану закупівлі
  [Arguments]  ${plan_id_hash}
  Go To  ${HOST}/opc/provider/plans/${plan_id_hash}/edit

################################################################
#                                                              #
#             End Навигация                                    #
#                                                              #
################################################################


################################################################
#                                                              #
#             Start Изменения плана                            #
#                                                              #
################################################################

Змінити в плані поле budget.description і зберегти
  [Arguments]   ${new_description}
  Check and change input field  ${locator.edit_plan_budget_description}  ${new_description}

Змінити в плані поле description і зберегти
  [Arguments]   ${new_description}
  ${locator.edit_tender_description}=  Set Variable  id=tender-description
  Check and change input field  ${locator.edit_tender_description}  ${new_description}

Змінити в плані поле budget.amount і зберегти
  [Arguments]   ${new_amount}
  ${valid_amount}=  convert_budget  ${new_amount}
  Check and change input field  ${locator.edit_plan_budget_amount}  ${valid_amount}

Змінити в плані поле items[0].deliveryDate.endDate і зберегти
  [Arguments]   ${new_date}
  ${valid_date}=  Get Substring  ${new_date}  0  10
  Check and change date field  ${locator.edit_plan_item_0_delivery_end_date}  ${valid_date}

Змінити в плані поле items[0].quantity і зберегти
  [Arguments]   ${new_item_quantity}
  Check and change input field  ${locator.edit_plan_item_0_quantity}  ${new_item_quantity}

Змінити в плані поле budget.period і зберегти
  [Arguments]  ${data}

  ${plan_start_date}=  Get Substring     '${data["startDate"]}'   0   4
  Check and change date field  ${locator.edit_plan_start_date}  ${plan_start_date}

  ${plan_end_date}=  Get Substring     '${data["endDate"]}'   0   4
  Check and change date field  ${locator.edit_plan_end_date}  ${plan_end_date}

################################################################
#                                                              #
#             End Изменения плана                              #
#                                                              #
################################################################

################################################################
#                                                              #
#             Start Получить плановую информацию               #
#                                                              #
################################################################

Отримати Планову інформацію про status
  ${plan_status_raw}=   Get Text   ${locator.view_plan_status}
  ${plan_status}=   convert_for_robot   ${plan_status_raw}
  [Return]  ${plan_status}

Отримати Планову інформацію про tender.procurementMethodType
  ${raw_string}=  _Return Element Text  ${locator.view_plan_type}
  ${result}=  convert_to_human_like_data  ${raw_string}
  [Return]  ${result}

Отримати Планову інформацію про budget.description
  Run Keyword And Return  _Return Element Text  ${locator.view_plan_description}

Отримати Планову інформацію про budget.currency
  Run Keyword And Return  _Return Element Text  ${locator.view_plan_currenry}

Отримати Планову інформацію про procuringEntity.name
  Run Keyword And Return  _Return Element Text  ${locator.view_plan_customer_name}

Отримати Планову інформацію про procuringEntity.identifier.scheme
  [Return]  UA-EDR

Отримати Планову інформацію про procuringEntity.identifier.id
  Run Keyword And Return  Return Element Text  ${locator.view_plan_customer_name_id}

Отримати Планову інформацію про procuringEntity.identifier.legalName
  Run Keyword And Return  Return Element Text  ${locator.view_plan_customer_legal_name}

Отримати Планову інформацію про classification.description
  ${raw_plan_classifier}=  Run Keyword  _Return Element Text  ${locator.view_plan_classification_description}
  ${result}=  Get Substring  ${raw_plan_classifier}  13
  [Return]  ${result}

Отримати Планову інформацію про classification.scheme
  ${raw_string}=  _Return Element Text  ${locator.view_plan_classification_scheme}
  ${result}=  convert_to_human_like_data  ${raw_string}
  [Return]  ${result}

Отримати Планову інформацію про classification.id
  ${raw_plan_classifier}=  _Return Element Text  ${locator.view_plan_classification_id}
  ${result}=  Get Substring  ${raw_plan_classifier}  0  10
  [Return]  ${result}

Отримати Планову інформацію про items[0].description
  ${raw_string}=  _Return Element Text  ${locator.view_plan_item_description}
  [Return]  ${raw_string}

Отримати Планову інформацію про items[0].quantity
  ${raw_text}=  _Return Element Text  ${locator.view_plan_item_quantity}
  ${result}=  string_convert_to_float  ${raw_text}
  [Return]  ${result}

Отримати Планову інформацію про items[0].deliveryDate.endDate
  #${raw_date}=  Run Keyword  _Return Element Text  ${locator.view_plan_item_delivery_date}
  #${result}=  convert_date_to_valid_date  ${raw_date}
  ${date}=  get_plan_data_from_cbd  ${data.plan_id_hash}
  Log To Console  [.] End data: ${date}
  [Return]  ${date}

Отримати Планову інформацію про items[0].unit.name
  Run Keyword And Return  _Return Element Text  ${locator.view_plan_item_measure_name}

Отримати Планову інформацію про items[0].classification.description
  ${raw_plan_classifier_description}=  Run Keyword  _Return Element Text  ${locator.view_plan_item_classificator_description}
  ${result}=  Get Substring  ${raw_plan_classifier_description}  13
  [Return]  ${result}

Отримати Планову інформацію про items[0].classification.scheme
  ${raw_string}=  _Return Element Text  ${locator.view_plan_item_classificator_scheme}
  ${result}=  convert_to_human_like_data  ${raw_string}
  [Return]  ${result}

Отримати Планову інформацію про items[0].classification.id
  ${raw_string}=  Run Keyword  _Return Element Text  ${locator.view_plan_item_classificator_id}
  ${result}=  Get Substring  ${raw_string}  0  10
  [Return]  ${result}

################################################################
#                                                              #
#             End Получить плановую информацию                 #
#                                                              #
################################################################
