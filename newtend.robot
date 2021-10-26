# v1.01

*** Settings ***
Library  Collections
Library  String
Library  DateTime

# services
Library   ./helper/newtend_service.py
Resource  ./helper/locators.robot
Resource  ./helper/helper.robot
Resource  ./helper/data.robot

# tender
Resource  ./tender/tender_create.robot

# plan
Resource  ./plan/plan.robot

# user
Resource  ./user/user.robot

# documents
Resource  ./document/document.robot

# question
Resource  ./question/question.robot

# contract
Resource  ./contract/contract.robot

# awards
Resource  ./awards/awards.robot

# refactor
#Resource  ./refactor.robot

*** Keywords ***

Подати цінову пропозицію в статусі draft
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [.] Make bid draft
  Make Bid Draft  @{ARGS}

Завантажити документ в ставку
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Download doc in bid

  ${username}=  Set Variable  ${ARGS[0]}
  ${document_file}=  Set Variable  ${ARGS[1]}
  ${tender_id}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  Go To Auction

  Add Doc To Bid  ${document_file}

Подати цінову пропозицію
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  Log To Console  [.] Make bid
  Make Bid  @{ARGS}

Змінити документ в ставці
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  Log To Console  [.] Change doc in bid

  ${username}=  Set Variable  ${ARGS[0]}
  ${document_file}=  Set Variable  ${ARGS[1]}
  ${tender_id}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  Go To Auction

  Sleep  90

################################################################
#                                                              #
#             Start Подготовительные шаги                      #
#                                                              #
################################################################

Підготувати клієнт для користувача
  [Arguments]  ${user}  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${user} ==  username
  Відкрити браузер  '${user}'
  Встановити розміри браузера  '${user}'
  Check user if him reg to login  ${user}
  Change Language to UKR
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-11-30 16:21:35

################################################################
#                                                              #
#             End Подготовительные шаги                        #
#                                                              #
################################################################

################################################################
#                                                              #
#             START ПЛАН - PLAN                                #
#                                                              #
################################################################

Створити план
  [ARGUMENTS]  @{ARGUMENTS}
  Log To Console  --- PLAN DATA ---
  Log To Console  ${ARGUMENTS[1]}
  Log To Console  --- PLAN END ---
  Change Language to UKR
  ${id}=  Create Plan  @{ARGUMENTS}
  Log To Console  [+] Create Plan ID: ${id}
  [Return]  ${id}

Пошук Плану По Ідентифікатору
  [Arguments]  ${username}  ${plan_uaid}
  Find Plan By UAID  ${plan_uaid}

Оновити сторінку з планом
  [Arguments]   ${username}    ${tender_uaid}
  Reload Page

Отримати інформацію із плану
  [Arguments]   @{ARGUMENTS}
  Run Keyword And Return  Отримати Планову інформацію про ${ARGUMENTS[2]}

Внести зміни в план
  [Arguments]   ${user_role}  ${plan_id}  ${field_what_need_change}  ${new_value_of_field}

  # searching for necessary Plan
  Перейти до редагування плану  ${g_data.plan_id_hash}

  # change plan
  ${result}=  Run Keyword  Змінити в плані поле ${field_what_need_change} і зберегти  ${new_value_of_field}

  # save plan
  Опубліковати план
  [Return]  ${result}

Додати предмет закупівлі в план
  [Arguments]  @{ARGUMENTS}
  # go to plan
  Перейти до редагування плану  ${g_data.plan_id_hash}
  # click to add item in plan
  Wait And Click  ${locator.edit_plan_item_add}

Видалити предмет закупівлі плану
  [Arguments]  @{ARGUMENTS}
  # go to plan
  Перейти до редагування плану  ${g_data.plan_id_hash}
  # click to button delete element from PLAN
  Wait And Click  ${locator.edit_plan_item_0_remove}

################################################################
#                                                              #
#             END ПЛАН - PLAN                                  #
#                                                              #
################################################################


################################################################
#                                                              #
#                    Tender                                    #
#                                                              #
################################################################ 

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_id}

  # if tender
  Find Tender By Id  ${tender_id}
  Sleep  2

  # make request and get tender data and put in global variable
  Log To Console  Username ${username}
  Run Keyword If  '${username}' != 'Newtend_Owner'  Put Tender In Global Verable  ${username}
  Sleep  1

Створити тендер
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}  ${criteria_guarantee}=None  ${criteria_lot}=None  ${criteria_llc}=None
  Change Language to UKR
  Create Tender  ${username}  ${tender_data}  ${plan_uaid}
  ${id}=  Set Variable  ${g_data.current_tender_id}
  [Return]  ${id}

Створити тендер з критеріями
  [Arguments]  ${username}  ${tender_data}  ${tender_id}  ${criteria_guarantee}=None  ${criteria_lot}=None  ${criteria_llc}=None
  Log To Console  ${username}
  Log To Console  ${tender_data}
  Log To Console  ${tender_id}
  Log To Console  ${criteria_guarantee}
  Log To Console  ${criteria_lot}
  Log To Console  ${criteria_llc}
  Create Tender  ${username}  ${tender_data}  ${tender_id}
  ${id}=  Set Variable  ${g_data.current_tender_id}
  [Return]  ${id}

Створити тендер другого етапу
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}

  # main action
  Create Tender  ${username}  ${tender_data}  ${plan_uaid}

  ${id}=  Set Variable  ${g_data.current_tender_id}
  Log To Console  [+] Create Tender ID: ${id}
  [Return]  ${id}

Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=   update_data_for_newtend   ${tender_data}
  [Return]   ${tender_data}


Внести зміни в тендер
  [Arguments]   ${user_role}  ${tender_id}  ${field_name}  ${field_value}

  # searching tender
  Find Tender By Id  ${tender_id}

  # need singup before edit button appear
  Run Keyword  SingUp Tender
  Sleep  3
  # go to edit
  Wait And Click  xpath=//a[@id="edit-tender-btn"]

  # change plan
  ${result}=  Run Keyword  Змінити в тендері поле ${field_name} і зберегти  ${field_value}

  # save
  Publish tender

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  Reload Page

Отримати інформацію із лоту
  [Arguments]  @{ARGUMENTS}
  Run Keyword And Return  Отримати лотову інформацію про ${ARGUMENTS[3]}    ${ARGUMENTS[2]}

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[2]}

Отримати інформацію із предмету
  [Arguments]  @{ARGUMENTS}
  Run Keyword And Return  Отримати інформацію із ${ARGUMENTS[3]}    ${ARGUMENTS[2]}
  
################################################################
#                                                              #
#                    End Tender                                #
#                                                              #
################################################################ 

################################################################
#                                                              #
#                    Tender OpenUA                             #
#                                                              #
################################################################ 


################################################################
#                                                              #
#                    Tender OpenUA                             #
#                                                              #
################################################################ 

################################################################
#                                                              #
#                    Documents                                 #
#                                                              #
################################################################ 

Завантажити документ
  [Arguments]  ${username}  ${document_file}  ${tender_id}  @{ARGUMENTS}
  Find Tender By Id  ${tender_id}
  ${document_for}=  Set Variable  tender
  ${document_type}=  Set Variable  notice
  Download Document  ${document_file}  ${document_for}  ${document_type}

Завантажити документ в лот
  [Arguments]  @{ARGUMENTS}
  Find Tender By Id  ${tender_id}
  ${document_for}=  Set Variable  lot
  ${document_type}=  Set Variable  notice
  Download Document  ${document_file}  ${document_for}  ${document_type}

################################################################
#                                                              #
#                    END Documents                             #
#                                                              #
################################################################ 

################################################################
#                                                              #
#                    Supplyer                                  #
#                                                              #
################################################################ 

Створити постачальника, додати документацію і підтвердити його
  [Arguments]  @{ARGUMENTS}
  Create suplier and add docs and confier him  @{ARGUMENTS}

################################################################
#                                                              #
#                    END Supplyer                              #
#                                                              #
################################################################ 

################################################################
#                                                              #
#                    Question                                  #
#                                                              #
################################################################

Задати питання
  [Arguments]  @{ARGUMENTS}
  Print Args  ${ARGUMENTS}
  Ask question  @{ARGUMENTS}

Задати запитання на тендер
  [Arguments]  @{ARGUMENTS}
  Print Args  @{ARGUMENTS}
  Ask question  @{ARGUMENTS}

Задати запитання на предмет
  [Arguments]  @{ARGUMENTS}
  Print Args  ${ARGUMENTS}
  Ask question  @{ARGUMENTS}

Задати запитання на лот
  [Arguments]  @{ARGUMENTS}
  Print Args  ${ARGUMENTS}
  Ask question  @{ARGUMENTS}

Відповісти на запитання
  [Arguments]  @{ARGUMENTS}
  Print Args  ${ARGUMENTS}
  Answer to question  @{ARGUMENTS}

Отримати інформацію із запитання
  [Arguments]  @{ARGUMENTS}
  Print Args  ${ARGUMENTS}
  ${result}=  Get Info From Question  @{ARGUMENTS}
  [Return]  ${result}

################################################################
#                                                              #
#                    END Question                              #
#                                                              #
################################################################

################################################################
#                                                              #
#                    Negotiation  (complains)                  #
#                                                              #
################################################################

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  Fail  Не реалізований функціонал

Порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  Fail  Не реалізований функціонал

################################################################
#                                                              #
#                    END Negotiation                           #
#                                                              #
################################################################

################################################################
#                                                              #
#                    Funders                                   #
#                                                              #
################################################################

Видалити донора
  [Arguments]  @{ARGUMENTS}
  Delete Funders  ${ARGUMENTS}

Додати донора
  [Arguments]  @{ARGUMENTS}
  Add Funders  ${ARGUMENTS}

################################################################
#                                                              #
#                    END Funders                               #
#                                                              #
################################################################

Отримати інформацію про mainProcurementCategory
  [Arguments]    @{ARGS}
  ${length_args}=  Get Length  ${ARGS}
  :FOR  ${INDEX}  IN RANGE  ${length_args}
  \  Log To Console  ARG '${INDEX}' - ${ARGS[${INDEX}]}


################################################################
#                                                              #
#                    Qualification                             #
#                                                              #
################################################################
Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${document_file}  ${tender_id}  ${bid_id}  @{ARGS}
  Log To Console  [+] Add Doc Qulification
  Log To Console  ${username}
  Log To Console  ${document_file}
  Log To Console  ${tender_id}
  Log To Console  ${bid_id}
  Find Tender By Id  ${tender_id}
  Go To Auction
  # wait all download
  Sleep  5
  Choise Bid  ${bid_id}
  # SingUp Qulifiacation
  Add Quilificaton Comission Document  ${document_file}
  Reload Page

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_id}  ${bid_id}  @{ARGS}
  Log To Console  [+] Aprove Qulification
  Log To Console  ${username}
  Log To Console  ${tender_id}
  Log To Console  ${bid_id}
  Find Tender By Id  ${tender_id}
  Go To Auction
  Sleep  5
  Choise Bid  ${bid_id}
  ${bool_confirm_bid}=  Run Keyword And Return Status  Confirm Bid
  Log To Console  [+] _Confirm bid status: ${bool_confirm_bid}
  ${bool_finish_torgi}=  Run Keyword And Return Status  Finish Torgi
  Log To Console  [+] _Finish torgi status: ${bool_finish_torgi}

Відxилити постачальника
  [Arguments]  ${username}  ${tender_id}  ${bid_id}  @{ARGS}
  Log To Console  [+] Aprove Qulification
  Log To Console  ${username}
  Log To Console  ${tender_id}
  Log To Console  ${bid_id}

  Find Tender By Id  ${tender_id}
  Go To Auction
  Sleep  5

  # choise accept button
  ${button_open_popup_approve_suplier}=  Set Variable  xpath=//button[@ng-click="decide('active')"]
  ${bid_decline}=  Get WebElement  xpath=//button[@ng-click="decide('unsuccessful')"]
  Wait And Click  ${bid_decline}

Відхилити кваліфікацію
  [Arguments]    @{ARGS}
  Log To Console  [+] Decline qulification
  # TODO
  Print Args  @{ARGS}

Скасувати кваліфікацію
  [Arguments]    @{ARGS}
  Log To Console  [+] Canceled qulification
  # TODO
  Print Args  @{ARGS}

Підтвердити кваліфікацію
  [Arguments]    @{ARGS}
  Log To Console  [+] Confirm qulification
  # TODO
  Print Args  @{ARGS}

Затвердити остаточне рішення кваліфікації
  [Arguments]    @{ARGS}
  Log To Console  [+] Approve qulification
  # TODO
  Print Args  @{ARGS}

################################################################
#                                                              #
#                    END Qualification                         #
#                                                              #
################################################################

################################################################
#                                                              #
#                    Contract                                  #
#                                                              #
################################################################

Завантажити документ у кваліфікацію
  [Arguments]  ${username}  ${document_file}  ${tender_uaid}  ${qualification_num}  @{args}
  Log To Console  [+] Download doc in qulification

  Log To Console  Username ${username}
  Log To Console  Doc ${document_file}
  Log To Console  Tender ${tender_uaid}
  Log To Console  Qualification num ${qualification_num}
  Log To Console  Args ${args}

  # find tender
  Find Tender By Id  ${tender_uaid}

  Download Document  ${document_file}  "tender"  "bidders"

Підтвердити підписання контракту
  [Arguments]    ${username}  ${tender_uaid}  ${contract_num}
  Log To Console  [+] Confirm contract
  Log To Console  ARG 0 - ${username}
  Log To Console  ARG 1 - ${tender_uaid}
  Log To Console  ARG 2 - ${contract_num}

  # go to tender
  Find Tender By Id  ${tender_uaid}

  # go to contracts
  Go To Contracts

  # choice contract
  Choise contract  ${contract_num}
  
  Confirm contract

################################################################
#                                                              #
#                    END Contract                              #
                                                              #
################################################################
dn
################################################################
#                                                              #
#                    Feature                                   #
#                                                              #
################################################################

Отримати інформацію із нецінового показника
  [Arguments]    @{ARGS}
  Log To Console  [+] Get Info From Reatures
  # TODO
  Print Args  @{ARGS}
  [Return]  1

Додати неціновий показник на тендер
  [Arguments]  ${username}  ${tender_id}  ${feature_date}
  Log To Console  [+] Add features in tender
  # TODO
  Print Args  @{ARGS}

  Find Tender By Id  ${tender_id}
  Create Feature  ${feature_date}
  Publish tender

Видалити неціновий показник
  [Arguments]    @{ARGS}
  Log To Console  [+] Delete features in tender
  # TODO
  Print Args  @{ARGS}

################################################################
#                                                              #
#                    END Feature                               #
#                                                              #
################################################################

Редагувати угоду
  [Arguments]    @{ARGS}
  Log To Console  [+] Edit contract
  # TODO
  Print Args  @{ARGS}

Змінити лот
  [Arguments]  ${username}  ${tender_id}  ${lot_id}  ${variable_chould_change}  ${variable_value}

  # TODO
  Print Args  ${ARGS}

  Find Tender By Id  ${tender_id}
  Go To Edit Tender

  Wait And Click  xpath=//input[@id="lot-id-0"]

  Publish tender
 
################################################################
#                                                              #
#                    Qulification                              #
#                                                              #
################################################################
  
Отримати інформацію про contracts[0].value.amountNet
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

  # go to contract
  Go To Contracts

  ${locator_conract_item}=  Set Variable  xpath=//a[@ui-sref="contract.overview({id: contract.id})"]
  ${tryingcount_number}=  Convert To Integer  10
  : FOR  ${try}  IN RANGE  ${tryingcount_number}
  \    ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator_conract_item}
  \    Exit For Loop IF    "${locator_exist}" == "True"
  \    Log To Console  [${try}] Try number
  \    Sleep  30
  \    Reload Page

  Wait And Click  xpath=//a[@ui-sref="contract.overview({id: contract.id})"]

  Wait Until Page Contains Element  xpath=//div[@id="view-contract-value-amount-net"]
  ${amountNet}= Get Text  xpath=//div[@id="view-contract-value-amount-net"]
  [Return]  ${amountNet}

Отримати інформацію про contracts[0].value.amount
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}

  # go to contact
  Go To Contracts
  Wait And Click  xpath=//a[@ui-sref="contract.overview({id: contract.id})"]

  Wait Until Page Contains Element  xpath=//div[@id="view-contract-value"]
  ${amount}= Get Text  xpath=//div[@id="view-contract-value"]
  [Return]  ${amount}

Отримати інформацію про complaintPeriod.endDate
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  ${complaintPeriod}=  Get Text  xpath=//div[@id="end-date-complaintPeriod"]
  [Return]  ${complaintPeriod}

Отримати інформацію із пропозиції
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  # TODO

Скасувати лот
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  # its in new complaints procedure
