** Settings ***
Resource  ../../newtend.robot

*** Keywords ***

#Подати цінову пропозицію
#  [Arguments]  @{ARGUMENTS}


Додати позицію
###  Не видно контролів додати пропозицію в хромі, потрібно скролити, скрол не працює. Обхід: додати лише 1 пропозицію + редагувати description для скролу.
  Click Element    ${locator.edit.add_item}
  Додати придмет   ${items[1]}   1

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
  Sleep     1
  Focus             ${locator.supplier_region}
  Click Element     ${locator.supplier_region}
  Sleep     1
  Click Element     xpath=//md-option[@value="${supplier_region}"]
  Sleep     1
  Wait And Type  ${locator.supplier_locality}        ${supplier_city}
  Wait And Type  ${locator.supplier_streetAddress}   ${supplier_street}
  Click Element     xpath=//md-select[@ng-model="vm.award.suppliers[0].identifier.scheme"]
  Click Element     xpath=//md-option[@value="UA-EDR"]
  Sleep     1
  Wait And Type  ${locator.supplier_ua-id}       ${supplier_edr}
  Clear Element Text    id=award-value-amount
  Wait And Type  id=award-value-amount   ${supplier_amount_int}
  Click Element     xpath=//md-checkbox[@name="qualified"]
  Sleep     2
  Click Element     xpath=//button[@ng-click="vm.createAward()"]

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

Підтвердити підписання контракту
  [Arguments]   @{ARGUMENTS}
  [Documentation]   For Reporting procedure flow, pressing finish btn in Trades tab
  ...      ${ARGUMENTS[0]} == username
  ...      ${ARGUMENTS[1]} == ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} == file_path
  log to console   arg0 - ${ARGUMENTS[0]}
  log to console   arg1 - ${ARGUMENTS[1]}
  log to console   arg2 - ${ARGUMENTS[2]}
  Wait Until Page Contains Element  xpath=//a[@ui-sref="tenderView.auction"]
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]

  Reload Page
# TODO: delete this part if OK
#  Sleep     3
#  : FOR   ${INDEX}   IN RANGE    1    10
#  \   Reload Page
#  \   Log To Console   .   no_newline=true
#  \   Sleep     3
#  \   ${count}=   Get Matching Xpath Count    xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
#  \   Exit For Loop If   '${count}' > '0'
  Wait Until Page Contains Element  xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]  20
  Click Element     xpath=//button[@ng-click="closeBids(lot.awardId, lot.contractId)"]
  # Waiting for Contracts Confirm modal window appear
  : FOR   ${INDEX}   IN RANGE    1    30
  \   Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//form[@name="closeBidsForm"]
  \   Exit For Loop If   '${count}' > '0'
  # ${contruct_number}=    Convert To String    ${ARGUMENTS[2]}
  Input Text    id=contractNumber   'contruct_number'
  Sleep     20
  Click Element     xpath=//button[@ng-click="closeBids()"]
  # Waiting for Contracts Finish modal window hide
  : FOR   ${INDEX}   IN RANGE    1    30
  \   #Log To Console   .   no_newline=true
  \   Sleep     2
  \   ${count}=   Get Matching Xpath Count   xpath=//form[@name="closeBidsForm"]
  \   Exit For Loop If   '${count}' < '1'
  Sleep     2
