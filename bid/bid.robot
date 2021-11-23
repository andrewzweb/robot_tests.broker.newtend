** Settings ***
Resource  ../../newtend.robot


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
  ${locator.bids_lots}=  Set Variable  xpath=//div[@ng-repeat="lot in lots track by $index"]
  ${locator.button_for_make_bid_in_lot}=  Set Variable  xpath=//button[@ng-show="!lot.lotValue"]

  # for example we choise first lot
  #${elements_lot}=  ${bid_currency}=  Run Keyword If  '${status_bid_with_value}' == 'False'  Get WebElements  ${locator.button_for_make_bid_in_lot}
  #${bid_currency}=  Run Keyword If  '${status_bid_with_value}' == 'False'  Wait And Click  ${elements_lot[0]}

  # input count
  ${locator.input_bid_amount}=  Set Variable  xpath=//input[@name="amount"]
  ${bid_amount}=  Convert To String  ${bid_amount}
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


Add Doc To Bid
  [Arguments]  ${username}  ${document_file}
  #${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  #Log To Console  Bid ID ${bid_id}

  # click to make bid
  ${locator.button_popup_make_bid}=  Set Variable  xpath=//a[@ui-sref="tenderView.ownBid"]
  Wait And Click  ${locator.button_popup_make_bid}

  Sleep  3
  # wait popup
  #${locator.popup_make_bid}=  Set Variable  xpath=//div[@class="modal-content"]
  #Wait Until Element Is Visible  ${locator.popup_make_bid}

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

Edit Bid Criteria
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${criteria_data}=  Set Variable  ${ARGS[2]}
  ${input_criteria_data_length}=  Get Length  ${criteria_data}

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


  # === снаяала оперделим сколько всего критериев
  # получим сначала все елементы
  ${elements_requirement}=  Get WebElements  xpath=//div[@ng-repeat="criteria in criterias track by $index"]
  # посчитаем количество всех елементов
  ${count_criteria_on_page}=  Get Length  ${elements_requirement}
  Log To Console  [*] Count criteria on page: ${count_criteria_on_page}

  # идем по циклу этих эдементов и по циклу данных которые нам прислали
  # для того чтобы заполнить эти критерии

  :FOR  ${criteria_index}  IN RANGE  ${count_criteria_on_page}
  \  # получить атрибут с элемента для подальшего сравнения
  \  ${data_requirement_group_id}=  Get Element Attribute  xpath=//div[@id="requirement_group_${criteria_index}_0"]@data-requirement_group_id
  \  Log To Console  [_] Criteria id: ${criteria_index} and attr ${data_requirement_group_id}
  \
  \  ${numb_index}=  Convert To Integer  ${criteria_index}
  \  ${current_data_item}=  Set Variable  ${criteria_data.data[${numb_index}]}
  \  Log Dictionary  ${current_data_item}
  \
  \  # получить значение именно value
  \  ${criteria_value}=  Get From Dictionary  ${current_data_item}  value
  \  Log To Console  [_] Criteria value: ${criteria_value}
  \  Run Keyword If  '${criteria_value}' == 'true'  Wait And Click  xpath=//div[@id="requirement_group_${criteria_index}_0"]//../md-checkbox[@ng-model="requirement.requirementResponse.value"]
  \
  \  # получить лист евиденцес где должен быть документ
  \  ${criteria_evidences}=  Get From Dictionary  ${current_data_item}  evidences
  \  # существует ил документ к данному критерию?
  \  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${criteria_evidences[0]}  relatedDocument
  \
  \  Log To Console  [${key_exist}] Add Doc To Criteria
  \  Run Keyword If  ${key_exist}  Add Doc To Criteria  ${current_data_item}  ${criteria_index}

  Save Criteria In Bid And Publish Bid


Add Doc To Criteria
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Add Doc To Criteria
  
  ${current_data_item}=  Set Variable  ${ARGS[0]}
  ${criteria_index}=  Set Variable  ${ARGS[1]}

  # --- добавить документ
  # получить лист евиденцес где должен быть документ
  ${criteria_evidences}=  Get From Dictionary  ${current_data_item}  evidences
  # существует ил документ к данному критерию?
  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${criteria_evidences[0]}  relatedDocument

  Log To Console  [_] Current criteria have doc: ${key_exist}

  # открыть селект документа
  Run Keyword If  ${key_exist}  Wait And Click  xpath=//div[@id="requirement_group_${criteria_index}_0"]//../md-select[@ng-model="requirement.requirementResponse.evidences[$index].relatedDocument.id"]
  Sleep  3

  # нажать на появившийся документ
  Run Keyword If  ${key_exist}  Wait And Click  xpath=//md-option[@ng-repeat="document in eligibilityDocuments"]
  Sleep  2

  # написать дескриптион к документу
  ${doc_title}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${criteria_evidences[0]}  title
  Run Keyword If  ${key_exist}  Wait And Type  xpath=//div[@id="requirement_group_${criteria_index}_0"]//../textarea  ${doc_title}

Save Criteria In Bid And Publish Bid
  #--- end
  Wait And Click  xpath=//button[@ng-click="saveCriteriaChanges()"]
  Sleep  5

  #Wait And Click  xpath=//button[@ng-click="signBid(currentBid)"]
  #Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  #Sleep  3

  Wait And Click  xpath=//button[@ng-click="publishBid()"]
