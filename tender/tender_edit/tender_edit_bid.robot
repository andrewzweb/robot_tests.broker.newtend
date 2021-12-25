** Settings ***
Resource  ../../newtend.robot

*** Keywords ***


Забрати позицію
  Click Element   xpath=//a[@title="Добавить лот"]/preceding-sibling::a

Create suplier and add docs and confier him
  [Arguments]   ${username}  ${tender_id}  ${tender_data}  ${document_file}

  Log To Console  [+] === Create suplier and add docs and confier him ===

  Find Tender By Id  ${tender_id}
  Go To Auction

  Create Suplier  ${tender_data}

  ${procurementMethodType}=  Get From Dictionary  ${USERS.users['${tender_owner}'].initial_data.data}  procurementMethodType
  Log To Console  [_] Type of Tender: ${procurementMethodType}

  Capture Page Screenshot  custom-screenshot-{index}.png
  # if its reporting
  Run Keyword If  '${procurementMethodType}' != 'negotiation'  Confirm Suplier  ${document_file}

  Capture Page Screenshot  custom-screenshot-{index}.png
  # if negotiation
  Run Keyword If  '${procurementMethodType}' == 'negotiation'  Confirm Suplier Old  ${document_file}

Create Suplier
  [Arguments]  ${tender_data}

  Log To Console  [+] Create Suplier

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
  Wait And Type  ${locator.supplier_ua-id}  ${supplier_edr}
  Clear Element Text  id=award-value-amount
  Wait And Type  id=award-value-amount   ${supplier_amount_int}
  Wait And Click   xpath=//md-checkbox[@name="qualified"]
  Sleep     2
  Wait And Click     xpath=//button[@ng-click="vm.createAward()"]


Confirm Suplier Old
  [Arguments]  ${document_file}

  Log To Console  [+]__ Confirm Suplier Old
  Log To Console  [+]__ Doc name: '${document_file}'

  # accept bid
  Wait And Click  xpath=//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]
  Sleep  2
  # download doc
  # clit to button for add document
  Wait And Click  xpath=//div[@ng-model="file"]
  Sleep  2

  # put in input
  Choose File  xpath=//input[@type="file"]  ${document_file}
  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");

  # download doc
  Wait And Click  xpath=//button[@ng-click="upload()"]
  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='sign()']");
  ...  element.removeAttribute("disabled");

  # sing up
  Wait And Click  xpath=//button[@ng-click="sign()"]
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  # Sleep  3

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='accept()']");
  ...  element.removeAttribute("disabled");

  # accept and close popup
  Wait And Click  xpath=//button[@ng-click="accept()"]

Confirm Suplier
  [Arguments]  ${document_file}

  # accept bid
  Wait And Click  xpath=//button[@ng-click="vm.decide(vm.award.id, 'active',vm.tender.procurementMethodType)"]


Make Contract For Tender  
  Wait And Click  xpath=//button[@data-test_id="close_tender"]  
  
  ${locator.input_contract_number}=  Set Variable  xpath=//input[@id="contractNumber"]
  Wait And Type  ${locator.input_contract_number}  0

  # change price
  # change price
  ${exist_amount}=  Run Keyword And Return Status  Get WebElement  id=contractValueAmount
  Run Keyword If  ${exist_amount}  Wait And Type  id=contractValueAmount  960

  ${exist_amountNet}=  Run Keyword And Return Status  Get WebElement  id=contractValueAmountNet
  Run Keyword If  ${exist_amountNet}  Wait And Type  id=contractValueAmountNet  800

  ${element_value_by_item}=  Get WebElements  id=itemUnitValueAmount
  ${count_items}=  Get Length  ${element_value_by_item}

  : FOR   ${index}  IN RANGE   ${count_items}
  \   ${element}=  Set Variable  ${element_value_by_item[${index}]}
  \   Wait And Type  xpath=//input[@name="${index}_itemUnitValueAmount"]  1

  Wait And Click  xpath=//button[@ng-click="closeBids()"]
  Log To Console  [+] Create Contract
  Sleep  3
