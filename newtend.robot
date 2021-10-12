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
Resource  ./user/user_helper.robot

# documents
Resource  ./document/document.robot

# question
Resource  ./question/question.robot

# complains
Resource  ./complains/complains.robot

# awards
Resource  ./awards/awards.robot

# refactor
#Resource  ./refactor.robot

*** Keywords ***

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
  #Встановити розміри браузера  '${user}'
  Check user if him reg to login  ${user}
  Change Language to UKR
  Add Cookie  autotest  1  domain=dev23.newtend.com  expiry=2021-10-30 16:21:35


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
  ${id}=  Створити план закупівлі  @{ARGUMENTS}
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



Створити тендер
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}  ${criteria_guarantee}=None  ${criteria_lot}=None  ${criteria_llc}=None
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
  Log To Console  ===============================================
  Log To Console  ${USERS.users['${username}'].tender_data}
  Log To Console  ===============================================
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

Пошук тендера по ідентифікатору
  [Arguments]  ${user}  ${tender_id}

  ${its_plan}=  check_its_plan  ${tender_id}

  # if plan go to plan
  Run Keyword If  ${its_plan}  Find Plan By UAID  ${tender_id}
  ${plan_tender_id}=  Run Keyword If  ${its_plan}   Click Element  xpath=//a[@ng-if="plan.tender_id"]
  #Run Keyword If  ${its_plan}  Find Tender By Id  ${plan_tender_id}

  # if tender
  Run Keyword If  ${its_plan} != True  Find Tender By Id  ${tender_id}
  Sleep  2

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
  Ask question  @{ARGUMENTS}

Задати запитання на тендер
  [Arguments]  @{ARGUMENTS}
  Ask question  @{ARGUMENTS}

Задати запитання на предмет
  [Arguments]  @{ARGUMENTS}
  Ask question  @{ARGUMENTS}

Задати запитання на лот
  [Arguments]  @{ARGUMENTS}
  Ask question  @{ARGUMENTS}

Відповісти на запитання
  [Arguments]  @{ARGUMENTS}
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
  [Arguments]  ${user}  ${document_file}  ${tender_id}  ${bid_id}

  Go To Auction

  Choise Bid  ${bid_id}

  Add Quilificaton Comission Document  ${document_file}

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_id}  ${bid_id}

  Log To Console  [+] Done
  
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
  Log To Console  ARG 0 - ${username}
  Log To Console  ARG 1 - ${tender_uaid}
  Log To Console  ARG 2 - ${contract_num}

  # go to tender
  Find Tender By Id  ${tender_uaid}

  # go to contracts
  Go To Auction

  ${locator.end_torgi}=  Set Variable  xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  Wait And Click  ${locator.end_torgi}

  ${locator.input_contract_number}=  Set Variable  xpath=//input[@id="contractNumber"]
  Wait And Type  ${locator.input_contract_number}  ${contract_num}

  # change price
  Wait And Type  id=contractValueAmount  96
  Wait And Type  id=contractValueAmountNet  80
  Wait And Type  id=itemUnitValueAmount  1

  Wait And Type  xpath=//button[@ng-click="closeBids()"]

  Go To Contracts
  
  # click to contract num
  Click Element  xpath=//*[contains(text(), '${contract_num}')]

  # confirm contract
  Wait And Type  xpath=button[@id="finish-contract-btn"]

  # click to button save
  Wait And Type  xpath=//button[@ng-click="save()"]

  # singup contract
  #SingUp Contract

  # finish contract
  Wait And Type  xpath=//button[@ng-click="terminateContract()"]

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
  # TODO
  Print Args  @{ARGS}
  [Return]  1

################################################################
#                                                              #
#                    END Feature                               #
#                                                              #
################################################################

Редагувати угоду
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

Змінити лот
  [Arguments]  @{ARGS}
  # TODO
  Print Args  ${ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${lot_id}=  Set Variable  ${ARGS[2]}
  ${variable_chould_change}=   Set Variable  ${ARGS[3]}
  ${variable_value}=   Set Variable  ${ARGS[4]}

  Find Tender By Id  ${tender_id}
  Go To Edit Tender

  Wait And Click  xpath=//input[@id="lot-id-0"]

  Publish tender
  
 
Додати неціновий показник на тендер  
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${feature_date}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Create Feature  ${feature_date}
  Publish tender

Видалити неціновий показник
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}
  
Відхилити кваліфікацію   
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

Скасувати кваліфікацію
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

Підтвердити кваліфікацію    
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

Затвердити остаточне рішення кваліфікації    
  [Arguments]    @{ARGS}
  # TODO
  Print Args  @{ARGS}

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


Make bid
  [Arguments]  @{ARGS}
  ${tender_id}=  Set Variable  ${ARGS[0]}  
  ${bid_data}=  Set Variable  ${ARGS[1]}  
  ${bid_amount}=  Get From Dictionary  ${bid_data}  amount
  
  # go to tender
  Find Tender By Id  ${tender_id}

  # click to make bid
  ${locator.button_popup_make_bid}=  Set Variable  xpath=//button[@ng-click="placeBid()"]
  Wait And Click  ${locator.button_popup_make_bid}

  # wait popup
  ${locator.popup_make_bid}=  Set Variable  xpath//div[@class="modal-content"]
  Wait Until Element Is Visible  ${locator.popup_make_bid}

  # click agree
  ${locator.button_agree_with_publish}=  Set Variable  xpath=//input[@ng-model="agree.value"]
  Wait And Click  ${locator.button_agree_with_publish}

  # click self qulified
  ${locator.button_agree_selt_quliffied}= xpath=//input[@ng-model="agree.selfQualified"]
  Wait And Click  ${locator.button_agree_selt_quliffied}

  # choise from lots
  ${locator.bids_lots}=  Set Variable  xpath=//div[@ng-repeat="lot in lots track by $index"]

  ${locator.button_for_make_bid_in_lot}=  Set Variable  xpath=//div[@ng-repeat="lot in lots track by $index"]/div/div/button[@ng-click="showBid($index)"]

  # for example we choise first lot
  ${elements_lot}=  Get WebElements  ${locator.button_for_make_bid_in_lot}
  Wait And Click  ${elements_lot[0]}
  
  # input count
  ${locator.input_bid_amount}=  Set Variable  xpath=//input[@name="amount"]
  Wait And Type  ${locator.input_bid_amount}  ${bid_amount}

  # confirm bid
  ${locator.place_a_bid}=  Set Variable  xpath=//button[@ng-click="placeBid()"]
  Wait And Click  ${locator.place_a_bid}

  # Wait page reload
  Sleep  3

  # potom menya perekidivaet na big page 

  # add doc vidpovidnist
  # choise type
  # save doc

  
  # need choise all criteria

  # choise first
  # and again choise first

  # save all criteria

  # pusblish bid

  # singin bid

Отримати інформацію про complaintPeriod.endDate
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
  ${complaintPeriod}=  Get Text  xpath=//div[@id="end-date-complaintPeriod"]
  [Return]  ${complaintPeriod}

Отримати інформацію із пропозиції
  [Arguments]  @{ARGS}
  Print Args  ${ARGS}
