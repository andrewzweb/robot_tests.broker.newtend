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

# complaints
Resource  ./complaint/complaint.robot

# bids
Resource  ./bid/bid.robot

*** Keywords ***

################################################################
#                                                              #
#             In work                                          #
#                                                              #
################################################################


Отримати інформацію про qualifications[0].status
  [Arguments]  @{ARGS}
  ${result}=  Get Info About Qualification   qualifications[0].status   @{ARGS}
  [Return]  ${result}

Отримати інформацію про qualifications[1].status
  [Arguments]  @{ARGS}
  ${result}=  Get Info About Qualification   qualifications[1].status   @{ARGS}
  [Return]  ${result}

Отримати інформацію про enquiryPeriod.clarificationsUntil
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}

Додати критерії в тендер другого етапу
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}

# this for esco 02qualification
Дискваліфікувати постачальника
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  # username
  # tender_id
  # number qualification 1


################################################################
#                                                              #
#             END In work                                      #
#                                                              #
################################################################


################################################################
#                                                              #
#             Start Подготовительные шаги                      #
#                                                              #
################################################################

Підготувати клієнт для користувача
  [Arguments]  ${user}  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${user} ==  username
  ${result}=  update_repo
  Log To Console  [${result}] Update
  Відкрити браузер  '${user}'
  Встановити розміри браузера  '${user}'
  Check user if him reg to login  ${user}
  Change Language to UKR
  Add Cookie  autotest  1  domain=autotest.newtend.com  expiry=2021-12-30 16:21:35

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
  Перейти до редагування плану  ${data.plan_id_hash}

  # change plan
  ${result}=  Run Keyword  Змінити в плані поле ${field_what_need_change} і зберегти  ${new_value_of_field}

  # save plan
  Опубліковати план
  [Return]  ${result}

Додати предмет закупівлі в план
  [Arguments]  @{ARGUMENTS}
  # go to plan
  Перейти до редагування плану  ${data.plan_id_hash}
  # click to add item in plan
  Wait And Click  ${locator.edit_plan_item_add}

Видалити предмет закупівлі плану
  [Arguments]  @{ARGUMENTS}
  # go to plan
  Перейти до редагування плану  ${data.plan_id_hash}
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
  [Arguments]  ${username}  ${tender_id}  @{ARGS}

  # if tender
  Find Tender By Id  ${tender_id}  ${username}
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
  # internal ID and put in global
  Get Internal ID
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
  Get Internal ID
  [Return]  ${id}

Створити тендер другого етапу
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}

  # main action
  Create Tender  ${username}  ${tender_data}  ${plan_uaid}

  ${id}=  Set Variable  ${g_data.current_tender_id}
  Log To Console  [+] Create Tender ID: ${id}
  Get Internal ID
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
  Sleep  3
  # go to edit
  Wait And Click  xpath=//a[@id="edit-tender-btn"]

  # change plan
  ${result}=  Run Keyword  Змінити в тендері поле ${field_name} і зберегти  ${field_value}

  # save
  Publish tender
  Sleep  5

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  Reload Page

  # новая функциональность для коректного отображения контракта тендера
  # и ждет синхронизации
  Run Keyword If  '${TEST_NAME}' == 'Відображення статусу підписаної угоди з постачальником переговорної процедури'  Smart Wait  Wait Until Page Contains Element  xpath=//a[@ng-repeat="contract in contracts"]

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
  ${result}=  Get Info From Question  @{ARGUMENTS}
  [Return]  ${result}

################################################################
#                                                              #
#                    END Question                              #
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


################################################################
#                                                              #
#                    Suplier                                   #
#                                                              #
################################################################
Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  @{ARGS}
  Add Doc To Qualification  @{ARGS}

Підтвердити постачальника
  [Arguments]  @{ARGS}
  Confirm Bid  @{ARGS}
  Sync Tender

Відxилити постачальника
  [Arguments]  ${username}  ${tender_id}  ${bid_id}  @{ARGS}
  Log To Console  [+] Decline Qulification
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

################################################################
#                                                              #
#                    END Suplier                               #
#                                                              #
################################################################

################################################################
#                                                              #
#                    Qualification                             #
#                                                              #
################################################################

Підтвердити кваліфікацію
  [Arguments]    @{ARGS}
  Aprove Qualification  @{ARGS}

Відхилити кваліфікацію
  [Arguments]  @{ARGS}
  Decline Qualification  @{ARGS}

Скасувати кваліфікацію
  [Arguments]    @{ARGS}
  Cancel Qualification  @{ARGS}

Затвердити остаточне рішення кваліфікації
  [Arguments]    @{ARGS}
  Finish Qualification  @{ARGS}

Отримати інформацію про qualificationPeriod.endDate
  [Arguments]    @{ARGS}
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
  [Arguments]  ${username}  ${document_file}  ${tender_id}  ${qualification_num}  @{args}
  Log To Console  [+] Download doc in qulification

  Log To Console  Username ${username}
  Log To Console  Doc ${document_file}
  Log To Console  Tender ${tender_uaid}
  Log To Console  Qualification num ${qualification_num}
  Log To Console  Args ${args}

  # find tender
  Find Tender By Id  ${tender_id}

  Download Document  ${document_file}  "tender"  "bidders"

Підтвердити підписання контракту
  [Arguments]    ${username}  ${tender_id}  ${contract_num}
  Log To Console  [+] Confirm contract
  Log To Console  ARG 0 - ${username}
  Log To Console  ARG 1 - ${tender_id}
  Log To Console  ARG 2 - ${contract_num}

  # go to tender
  Find Tender By Id  ${tender_id}

  # go to auction
  Go To Auction

  Create Contract

Завантажити документ в угоду
  [Arguments]  @{ARGS}
  Download Document To Contract  @{ARGS}

Вказати період дії угоди
  [Arguments]  @{ARGS}
  Set Date For Contract  @{ARGS}

Встановити дату підписання угоди
  [Arguments]  @{ARGS}
  Set Date Sing For Contract  @{ARGS}

Встановити ціну за одиницю товару в контракті
  [Arguments]  @{ARGS}
  Log To Console  [+] Set price for item in contract

################################################################
#                                                              #
#                    END Contract                              #
                                                              #
################################################################

################################################################
#                                                              #
#                    Feature                                   #
#                                                              #
################################################################

Отримати інформацію із нецінового показника
  [Arguments]    @{ARGS}
  Log To Console  [+] Get Info From Reatures
  Print Args  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${hash_id}=  Set Variable  ${ARGS[2]}
  ${field}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Sleep  2
  ${result}=  Get Feature Title  ${hash_id}
  [Return]  ${result}

Додати неціновий показник на тендер
  [Arguments]  ${username}  ${tender_id}  ${feature_date}
  Log To Console  [+] Add features in tender
  # TODO
  Print Args  ${username}  ${tender_id}  ${feature_date}
  Find Tender By Id  ${tender_id}
  Go To Edit Tender
  Add New Feature  ${feature_date}
  Sleep  10
  Publish tender
  
Видалити неціновий показник
  [Arguments]  ${username}  ${tender_id}  ${feature_id}

  Log To Console  [+] Delete features in tender
  Print Args  ${username}  ${tender_id}  ${feature_id}
  # ARG[0] - Newtend_Owner
  # ARG[1] - UA-2021-11-03-000401-c
  # ARG[2] - f-02660b81

  Find Tender By Id  ${tender_id}
  Go To Edit Tender
  Delete Feature  ${feature_id}
  #Delete All Features
  Publish tender


  Log To Console  Internal ID: ${data.tender_internal_id}
  ${tender}=  Return Tender Obj  ${data.tender_internal_id}
  Log  ${tender}
  Set To Dictionary  ${USERS.users['Newtend_Owner'].tender_data.data}  features=${tender['data']['features']}

Get Internal ID
  #https://autotest.newtend.com/opc/provider/tender/f5926f5a8d8a4350b7eb92d471729f74/overview
  ${location}=  Get Location
  ${internal_id}=  Get Substring  ${location}  -41  -9
  Set Global Variable  ${data.tender_internal_id}  ${internal_id}
  Log To Console  [+] Get Tender Internal ID: ${internal_id}
  [Return]  ${internal_id}

Custom Get Internal ID
  [Arguments]  ${start}  ${end}
  ${location}=  Get Location
  ${internal_id}=  Get Substring  ${location}  ${start}  ${end}
  Set Global Variable  ${data.tender_internal_id}  ${internal_id}
  Log To Console  [+] Get Custom Tender Internal ID: ${internal_id}
  [Return]  ${internal_id}

  
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


################################################################
#                                                              #
#                    Complaints                                #
#                                                              #
################################################################

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  Fail  Не реалізований функціонал

Порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  Fail  Не реалізований функціонал

Скасувати лот
  [Arguments]  @{ARGS}
  ${cancellation_data}=  Cancelled Lot  @{ARGS}
  [Return]  ${cancellation_data}

Створити чернетку вимоги/скарги на скасування
  [Arguments]  @{ARGS}
  ${result}=  Create draft complaint to cancelled tender  @{ARGS}
  [Return]  ${result}

Змінити статус скарги на скасування
  [Arguments]  @{ARGS}
  Complaint change status  @{ARGS}
  
Створити чернетку скарги про виправлення умов закупівлі
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${id}=  Create Draft Complaint  @{ARGS}
  [Return]  ${id}

Отримати інформацію із скарги
  [Arguments]  @{ARGS}
  ${result}=  Get Info From Complaints  @{ARGS}
  [Return]  ${result}

Завантажити документацію до вимоги
  [Arguments]  @{ARGS}
  Download document to complaint  @{ARGS}

Виконати оплату скарги
  [Arguments]  @{ARGS}
  Complaint publish  @{ARGS}

Змінити статус скарги
  [Arguments]  @{ARGS}
  Complaint change status  @{ARGS}

Скасувати закупівлю
  [Arguments]  @{ARGS}
  ${complaint_data}=  Cancelled Tender  @{ARGS}
  [Return]  ${complaint_data}

Створити чернетку скарги про виправлення умов лоту
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${id}=  Create Draft Complaint Of Lot  @{ARGS}
  [Return]  ${id}

Скасувати cancellation
  [Arguments]  @{ARGS}
  Cancel Cancelled Tender  @{ARGS}

Створити чернетку вимоги/скарги про виправлення кваліфікації учасника
  [Arguments]  @{ARGS}
  ${result}=  Make Complaint To Qualification  @{ARGS}
  [Return]  ${result}

Створити чернетку вимоги/скарги про виправлення визначення переможця
  [Arguments]  @{ARGS}
  ${result}=  Make Complaint To Award  @{ARGS}
  [Return]  ${result}

Завантажити документ до скарги в окремий об'єкт
  [Arguments]  @{ARGS}
  Download Document To Qualification Complaint  @{ARGS}

Змінити статус скарги на визначення пре-кваліфікації учасника
  [Arguments]  @{ARGS}
  Change Status To Complaint  @{ARGS}

Змінити статус скарги на визначення переможця
  [Arguments]  @{ARGS}
  Complaint change status  @{ARGS}

################################################################
#                                                              #
#                    END Complaints                            #
#                                                              #
################################################################

Скасування рішення кваліфікаційної комісії
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}

Отримати інформацію про mainProcurementCategory
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}

################################################################
#                                                              #
#                    BID                                       #
#                                                              #
################################################################

# ---- main ----
Подати цінову пропозицію
  [Arguments]  @{ARGS}
  Log To Console  [+] Make price bid
  Make bid  ${ARGS}

Подати цінову пропозицію в статусі draft
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [.] Make bid
  Make Bid Draft  @{ARGS}

Завантажити відповіді на критерії закупівлі
  [Arguments]    @{ARGS}
  Edit Bid Criteria  @{ARGS}

# ---- options ----

Додати позицію
  [Arguments]  @{ARGS}
  Log To Console  [+] Add bid
  Make bid  ${ARGS}

Отримати інформацію із пропозиції
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  # TODO
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${field}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  ${result}=  Run Keyword And Return  Отримати інформацію із пропозиції із поля ${field}

  [Return]  ${result}

Отримати інформацію із пропозиції із поля value.amount
  ${value_amount}=  Get Text  xpath=//div[@class="bid-item__amount ng-binding ng-scope"]
  ${result}=  convert_bid_amount  ${value_amount}
  [Return]  ${result}

Змінити цінову пропозицію
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  #Chagenge bid

# --- add doc in bid ---

Завантажити документ в ставку
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Download doc in bid

  ${username}=  Set Variable  ${ARGS[0]}
  ${document_file}=  Set Variable  ${ARGS[1]}
  ${tender_id}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}

  Go To Create Bid

  # посмотреть есть ли в ставке документы если есть
  # то появляется другое меню
  ${button_upload_doc}=  Set Variable  xpath=//button[@ng-click="uploadDocument()"]
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${button_upload_doc}

  Log To Console  [_] Button upload doc exist '${locator_exist}'
  Run Keyword If  '${locator_exist}' == 'True'  Upload Doc In Second Time  ${username}  ${document_file}
  Run Keyword If  '${locator_exist}' == 'False'  Add Doc To Bid  ${username}  ${document_file}

Змінити документ в ставці
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  Log To Console  [.] Change doc in bid

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${document_file}=  Set Variable  ${ARGS[2]}
  ${document_id}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Go To Create Bid

  Change Doc From Bid  ${username}  ${document_file}  ${document_id}


################################################################
#                                                              #
#                    END BID                                   #
#                                                              #
################################################################

