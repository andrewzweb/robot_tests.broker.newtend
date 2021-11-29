** Settings ***
Resource  ../newtend.robot


*** Keywords ***

Make Bid Draft
  [Arguments]  @{ARGS}
  Make Bid  @{ARGS}

Make Bid
  [Arguments]  @{ARGS}
#  ARG[0] - Newtend_Provider1
#  ARG[1] - UA-2021-10-25-000084-d
#  ARG[2] - data:
#    lotValues:
#    -   relatedLot: 507cd84121144dfe9029ef359261d4c0
#        value:
#            amount: 75338886.75
#            currency: UAH
#            valueAddedTaxIncluded: true
#    status: draft
#    tenderers:
#    -   address:
#            countryName: Україна
#            countryName_en: Ukraine
#            countryName_ru: Украина
#            locality: м. Київ
#            postalCode: '04444'
#            region: м. Київ
#            streetAddress: вулиця Тестова, 32
#        contactPoint:
#            email: e_mail_test@ukr.net
#            faxNumber: 333-44-55
#            name: Другий тестовий ФОП
#            telephone: '+380972223344'
#            url: http://webpage.com.ua
#        identifier:
#            id: '2894905868'
#            legalName: Тестовий ФОП 2
#            scheme: UA-EDR
#        name: Тестовий ФОП 2
#        scale: mid
#  ARG[3] - [u'l-3aafa6e4']

  Log To Console  [.] === Make bid ===

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${bid_data}=  Set Variable  ${ARGS[2]}

  ${status_bid_with_value}=  Exist key in dict  ${bid_data.data}  value
  Log To Console  Bid not for lot : ${status_bid_with_value}

  ${bid_amount}=  Run Keyword If  '${status_bid_with_value}' == 'True'  Get From Dictionary  ${bid_data.data.value}  amount
  ...  ELSE  Get From Dictionary  ${bid_data.data.lotValues[0].value}  amount

  ${bid_currency}=  Run Keyword If  '${status_bid_with_value}' == 'True'  Get From Dictionary  ${bid_data.data.value}  currency
  ...  ELSE  Get From Dictionary  ${bid_data.data.lotValues[0].value}  currency

  ${bid_tax}=  Run Keyword If  '${status_bid_with_value}' == 'True'  Get From Dictionary  ${bid_data.data.value}  valueAddedTaxIncluded
  ...  ELSE  Get From Dictionary  ${bid_data.data.lotValues[0].value}  valueAddedTaxIncluded

  # go to tender
  Find Tender By Id  ${tender_id}

  # click to make bid
  ${locator.button_popup_make_bid}=  Set Variable  xpath=//button[@ng-click="placeBid()"]
  Wait And Click  ${locator.button_popup_make_bid}

  # wait popup
  ${locator.popup_make_bid}=  Set Variable  xpath=//div[@class="modal-content"]
  Wait Until Element Is Visible  ${locator.popup_make_bid}

  # click agree
  ${locator.button_agree_with_publish}=  Set Variable  xpath=//input[@ng-model="agree.value"]
  Select Checkbox  ${locator.button_agree_with_publish}

  # click self qulified
  ${locator.button_agree_selt_quliffied}=  Set Variable  xpath=//input[@ng-model="agree.selfQualified"]
  Select Checkbox  ${locator.button_agree_selt_quliffied}

  # choise from lots
  ${bid_with_lots}=  Run Keyword And Return Status  Get Webelements  xpath=//div[@ng-repeat="lot in lots track by $index"]
  Log To Console  [ ] Bid with criteria: '${bid_with_lots}'

  Run Keyword If  ${bid_with_lots}  Wait And Click  xpath=//button[@ng-show="!lot.lotValue"]

  # есть ставка мультилотовая и у нее есть критерии то нужно эти критериии нажать потомучто дальше мы не
  # не поедем так сказать

  ${element_dropdown_exist}=  Run Keyword And Return Status  Get WebElement  xpath=//a[@class="dropdown-toggle ng-binding"]
  Run Keyword If  ${bid_with_lots} and ${element_dropdown_exist}  Wait And Click  xpath=//a[@class="dropdown-toggle ng-binding"]
  Run Keyword If  ${bid_with_lots} and ${element_dropdown_exist}  Sleep  2
  Run Keyword If  ${bid_with_lots} and ${element_dropdown_exist}  Wait And Click  xpath=//a[@id="feature_item_0_0_0"]  

  # input count
  ${locator.input_bid_amount}=  Set Variable  xpath=//input[@name="amount"]
  ${bid_amount}=  Convert To String  ${bid_amount}
  Wait And Type  ${locator.input_bid_amount}  ${bid_amount}

  # confirm bid
  ${locator.place_a_bid}=  Set Variable  xpath=//button[@ng-click="placeBid()"]
  Wait And Click  ${locator.place_a_bid}

  # Wait page reload
  Sleep  3


Edit Bid Criteria
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}

  # ARG[0] - Newtend_Provider1
  # ARG[1] - UA-2021-11-19-000185-c
  # ARG[2] - data:
  # -   description: Requirement response description
  #     evidences:
  #     -   relatedDocument:
  #             id: '123543523452345'
  #             title: /tmp/d-7d344b94similiquem_egL8.docx
  #         title: Evidence of Requirement response
  #         type: document
  #     requirement:
  #         id: c6d46ac624ed421dbe7f1b2782de1344
  #         title: Вид та умови надання забезпечення тендерних пропозицій
  #     title: Requirement response title
  #     value: 'true'
  # -   description: Requirement response description
  #     evidences: []
  #     requirement:
  #         id: c4038c796fc4464aa3e92ffe012640c9
  #         title: розмір та умови надання забезпечення виконання договору про закупівлю
  #     title: Requirement response title
  #     value: 'true'

  Log To Console  [.] === Edit criteria in bid ===

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${criteria_data}=  Set Variable  ${ARGS[2]}

  ${input_criteria_data_length}=  Get Length  ${criteria_data.data}
  Log To Console  [*] Count criteria on test data: ${input_criteria_data_length}

  # === снаяала оперделим сколько всего критериев
  # получим сначала все елементы
  ${elements_requirement}=  Get WebElements  xpath=//div[@ng-repeat='requirement in requirementGroup.requirements track by $index']
  # посчитаем количество всех елементов
  ${count_requirement_on_page}=  Get Length  ${elements_requirement}
  Log To Console  [*] Count criteria on page: ${count_requirement_on_page}

  # идем по циклу этих эдементов и по циклу данных которые нам прислали
  # для того чтобы заполнить эти критерии

  :FOR  ${element}  IN RANGE  ${count_requirement_on_page}
  \  Log To Console  [-] --------------------------
  \  ${current_element_id}=  Set Variable  ${elements_requirement[${element}].get_attribute('id')}
  \  Log To Console  ${current_element_id}
  \  ${current_element_hash}=  Set Variable  ${elements_requirement[${element}].get_attribute('data-requirement_id')}
  \  Log To Console  ${current_element_hash}
  \
  \  # вернуть элемент
  \  # если он есть
  \  ${number}=  return_number_element_check_hash  ${criteria_data}  ${current_element_hash}
  \
  \  Run Keyword If  '${number}' != 'None'  Log To Console  [+] ID: ${current_element_id}| HASH ${current_element_hash} | Number ${number}
  \
  \  # заполняем если элемент подходит
  \  Run Keyword If  '${number}' != 'None'  Edit Criteria Item  ${criteria_data}  ${number}  ${current_element_id}

  Log To Console  [+] Save criteria
  Save Criteria In Bid And Publish Bid
  ${status}=  Run Keyword And Return Status   Wait Until Page Contains Element  xpath=//button[@ng-click="confirm()"]  60
  Run Keyword If  ${status}  SingUp Bid

SingUp Bid
  Wait Until Page Contains Element  xpath=//button[@ng-click="confirm()"]  60
  Wait And Click  xpath=//button[@ng-click="confirm()"]
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]

 Edit Criteria Item
  [Arguments]    @{ARGS}
  ${data_list}=  Set Variable  ${ARGS[0]}
  ${number}=  Set Variable  ${ARGS[1]}
  ${id_current}=  Set Variable  ${ARGS[2]}

  Log To Console  [.] Edit Criteria Item |${number} | ${id_current}

  # берем нужный елемент
  ${current_element}=  Set Variable  ${data_list.data[${number}]}

  # берем непосредственно значение ответа и принтуем
  ${current_element_value}=  Get From Dictionary  ${current_element}  value
  Log To Console  [*] Requirement value ${number}: ${current_element_value}

  # если значение true то нажимаем на кнопку
  Run Keyword If  '${current_element_value}' == 'true'  Wait And Click  xpath=//div[@id="${id_current}"]//../md-checkbox[@ng-model="requirement.requirementResponse.value"]

  # достаем евиденцес
  ${current_element_evidence}=  Get From Dictionary  ${current_element}  evidences
  # проверяем есть ли что-то внутри
  ${evidence_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${current_element_evidence[0]}  relatedDocument
  Log To Console  [!] Evidence exist: ${evidence_exist}
  # если да то получаем тайтл и документ
  ${current_element_evidence_title}=  Run Keyword If  ${evidence_exist}  Get From Dictionary  ${current_element_evidence[0]}  title

  # если в критерии есть док то нажать на элемент
  Run Keyword If  ${evidence_exist}  Log To Console  [+] Click add doc button
  Run Keyword If  ${evidence_exist}  Select From List By Index  xpath=//div[@id="${id_current}"]//../select[@ng-model="requirement.requirementResponse.evidences[$index].relatedDocument.id"]  1

  # добавить описание к документу или эвиденс
  Run Keyword If  ${evidence_exist}  Wait And Type  xpath=//div[@id="${id_current}"]//../textarea  ${current_element_evidence_title}
  

Save Criteria In Bid And Publish Bid
  #--- end
  Wait And Click  xpath=//button[@ng-click="saveCriteriaChanges()"]
  Sleep  5
  Wait And Click  xpath=//button[@ng-click="publishBid()"]
  Sleep  5

Add Doc To Bid
  [Arguments]  ${username}  ${document_file}

  Log To Console  [.] === Add doc in bid ===

  # закртыть меню которое показывает деньги на счету
  Execute Javascript    window.document.getElementById('wallet-menu').style.display = "None";

  # click to open popup
  ${locator.button_open_popup_download_doc_to_bid}=  Set Variable  xpath=//button[@ng-model="selected.files"]
  Wait And Click  ${locator.button_open_popup_download_doc_to_bid}

  # choice file
  ${locator.input_download_file}=  Set Variable  xpath=//input[@type="file"]
  Choose File  ${locator.input_download_file}  ${document_file}

  # select doc ralation for
  ${locator.select_dropdown_document_type}=  Set Variable  xpath=//md-select[@ng-model="file.documentType"]
  Wait And Click  ${locator.select_dropdown_document_type}
  Sleep  2

  # type:
  # value="technicalSpecifications"  - Технічні специфікації
  # value="qualificationDocuments"  - Документи, що підтверджують кваліфікацію
  # value="eligibilityDocuments"  - Документи, що підтверджують відповідність
  # value="commercialProposal"  - Цінова пропозиція
  # value="billOfQuantity"  - Кошторис (розрахунок вартості)
  # value="evidence"  - Пояснення/обгрунтування
  # value="winningBid"  - Ціна за одиницю товару (послуги)

  ${locator.select_type_option}=  Set Variable  xpath=//md-option[@value="eligibilityDocuments"]
  Wait And Click  ${locator.select_type_option}

  ${locator.button_save_document}=  Set Variable  xpath=//button[@ng-click="saveDocumentsChanges()"]
  Wait And Click  ${locator.button_save_document}

  # wait doc download
  Sleep   10

  # try to fake document response
  ${fake_response}=    fake_document_response    ${document_file}
  Set To Dictionary  ${USERS.users['${username}']}   documents=${fake_response}


Upload Doc In Second Time
  [Arguments]  ${username}  ${document_file}

  Log To Console  [+] === Upload Doc In Second Time ===

  # открыть попап
  Wait And Click  xpath=//button[@ng-click="uploadDocument()"]
  Sleep  3

  # выбрать тип документа
  Select From List By Value  xpath=//select[@ng-model="document.documentType"]  eligibilityDocuments

  # выбрать открытость
  Select From List By Value  xpath=//select[@ng-model="document.confidentiality"]  public

  # нажать на добавить
  Wait And Click  xpath=//button[@ng-disabled="loadInProgress"]

  # загрузить файл
  Sleep  2
  Choose File  xpath=//input[@type='file']  ${document_file}
  Sleep  3

  # нажать на кнопку загрузить
  Wait And Click  xpath=//button[@ng-click="upload()"]
  Sleep  5


Change Doc From Bid
  [Arguments]  ${username}  ${document_file}  ${document_id}

  Log To Console  [+] === Change Doc From Bid ===

  # посмотрим сколько документов в биде
  Wait Until Page Contains Element  xpath=//div[@ng-repeat="document in allBidDocuments track by $index"]
  ${doc_elements}=  Get Webelements  xpath=//div[@ng-repeat="document in allBidDocuments track by $index"]

  # посчитать сколько элементов
  ${doc_elements_len}=  Get Length   ${doc_elements}
  Log To Console  [+] Current count doc in bid: ${doc_elements_len}

  # в цикле начать итерацию по лементам
  :FOR  ${index}  IN RANGE  ${doc_elements_len}
  \  # получить title элемента
  \  ${title}=  Get Text  ${doc_elements[${index}]}
  \  #Log To Console  [_] Get title doc: ${title}
  \  # посмотреть вхождение айдишника в title
  \  ${status}=  is_one_string_include_other_string  ${title}  ${document_id}
  \  Log To Console  [_] Get doc_id in title: (status: ${status} | doc_id: ${document_id})
  \  Execute Javascript    window.document.getElementById('wallet-menu').style.display = "None";
  \  # если вхождение есть то нажать на кнопочку заментить
  \  Run Keyword If  ${status}  Wait And Click  xpath=//div[@id="bid_doc_1"]/..//i[@class="glyphicon glyphicon-refresh"]
  \  # загрузить документ
  \  Run Keyword If  ${status}  Choose File  xpath=//input[@type="file"]  ${document_file}
  \  Run Keyword If  ${status}  Wait And Click  xpath=//button[@ng-click="confirm()"]
  # подождать
  Sleep  3

Отримати інформацію із пропозиції із поля status
  ${result}=  Get Text xpath=//div[@id="bid-status"]
  [Return]  ${result}
