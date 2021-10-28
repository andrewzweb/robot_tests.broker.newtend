** Settings ***
Resource  ../../newtend.robot

*** Keywords ***

Подати цінову пропозицію
  [Arguments]  @{ARGS}
  Log To Console  [+] Make price bid
  Print Args  ${ARGS}
  Make bid  ${ARGS}

Додати позицію
  [Arguments]  @{ARGS}
  Log To Console  [+] Add bid
  Print Args  ${ARGS}
  Make bid  ${ARGS}

Забрати позицію
  Click Element   xpath=//a[@title="Добавить лот"]/preceding-sibling::a

Create suplier and add docs and confier him
  [Arguments]   ${username}  ${tender_id}  ${tender_data}  ${document_file}
  [Documentation]   Adding user into reporting procedure

  newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_id}
  Sleep     3
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]

  # Getting information about participant
  ${supplier_name}=    Get From Dictionary     ${tender_data.data.suppliers[0].contactPoint}    name
  ${supplier_email}=   Get From Dictionary     ${tender_data.data.suppliers[0].contactPoint}    email
  ${supplier_phone}=   Get From Dictionary     ${tender_data.data.suppliers[0].contactPoint}    telephone
  ${supplier_site}=    Get From Dictionary     ${tender_data.data.suppliers[0].contactPoint}    url
  # Supplier address
  ${supplier_country}=  Get From Dictionary    ${tender_data.data.suppliers[0].address}     countryName
  ${supplier_city}=     Get From Dictionary    ${tender_data.data.suppliers[0].address}     locality
  ${supplier_zip}=      Get From Dictionary    ${tender_data.data.suppliers[0].address}     postalCode
  ${supplier_region}=   Get From Dictionary    ${tender_data.data.suppliers[0].address}     region
  ${supplier_street}=   Get From Dictionary    ${tender_data.data.suppliers[0].address}     streetAddress
  # Supplier identification number and Name
  ${supplier_edr}=         Get From Dictionary   ${tender_data.data.suppliers[0].identifier}   id
  ${supplier_legalName}=   Get From Dictionary   ${tender_data.data.suppliers[0].identifier}   legalName
  ${supplier_full_name}=   Get From Dictionary   ${tender_data.data.suppliers[0]}         name
  # Supplier value
  ${supplier_amount}=      Get From Dictionary   ${tender_data.data.value}   amount
  ${supplier_amount_int}=  Convert To String     ${supplier_amount}


  Wait And Click  xpath=//button[@ng-click="createAward()"]

  Wait And Type  ${locator.supplier_company_name}  ${supplier_full_name}
  Wait And Type  ${locator.supplier_legal_name}    ${supplier_legalName}
  Wait And Type  ${locator.supplier_url}           ${supplier_site}
  Wait And Type  ${locator.supplier_phone}           ${supplier_phone}
  Wait And Type  ${locator.supplier_name}            ${supplier_name}
  Wait And Type  ${locator.supplier_email}           ${supplier_email}
  Wait And Type  ${locator.supplier_zip}             ${supplier_zip}
  Sleep   1
  Focus             ${locator.supplier_region}
  Click Element     ${locator.supplier_region}
  Sleep   1
  Click Element     xpath=//md-option[@value="${supplier_region}"]
  Sleep   1
  Wait And Type  ${locator.supplier_locality}        ${supplier_city}
  Wait And Type  ${locator.supplier_streetAddress}   ${supplier_street}
  Click Element     xpath=//md-select[@ng-model="vm.award.suppliers[0].identifier.scheme"]
  Sleep   1
  Click Element     xpath=//md-option[@value="UA-EDR"]
  Sleep   1
  Wait And Type  ${locator.supplier_ua-id}       ${supplier_edr}
  Clear Element Text    id=award-value-amount
  Wait And Type  id=award-value-amount   ${supplier_amount_int}
  Wait And Click   xpath=//md-checkbox[@name="qualified"]
  Sleep     2
  Wait And Click     xpath=//button[@ng-click="vm.createAward()"]

  # accept bid
  Wait And Click  xpath=//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]

  # download doc
  ${locator.suplier_add_doc_button}=  Set variable  xpath=//button[@ng-click="upload.uploadContract(lot.awardId, lot.contractId)"]
  # add document
  Wait And Click  ${locator.suplier_add_doc_button}
  # wait form show
  Wait Until Element Is Visible  ${locator.documents_form}
  # choise type
  ${data.dicument_type}=  Set variable  notice
  Select From List By Value  ${locator.document_type}  ${data.dicument_type}
  Wait And Click  ${locator.document_file_button}
  Sleep  2
  Wait Until Page Contains Element  ${locator.document_file}
  Choose File  ${locator.document_file}  ${document_file}
  Wait And Click  ${locator.documents_send_document}

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

  ${bid_amount}=  Run Keyword If  '${status_bid_with_value}' == True  Get From Dictionary  ${bid_data.data.value}  amount
  ...  ELSE  Get From Dictionary  ${bid_data.data.lotValues[0].value}  amount

  ${bid_currency}=  Run Keyword If  '${status_bid_with_value}' == True  Get From Dictionary  ${bid_data.data.value}  currency
  ...  ELSE  Get From Dictionary  ${bid_data.data.lotValues[0].value}  currency

  ${bid_tax}=  Run Keyword If  '${status_bid_with_value}' == True  Get From Dictionary  ${bid_data.data.value}  valueAddedTaxIncluded
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
  ${elements_lot}=  Get WebElements  ${locator.button_for_make_bid_in_lot}
  Wait And Click  ${elements_lot[0]}
  
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

  ${document_name}=  Convert To String   ${document_file}
  Set To Dictionary  ${USERS.users['${username}']}   documents=${document_name}

