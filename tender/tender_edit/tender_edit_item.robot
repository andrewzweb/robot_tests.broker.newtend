*** Keywords ***

Add Item
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items_name
  ...      ${ARGUMENTS[1]} ==  items_data
  ...      ${ARGUMENTS[2]} ==  items_other
  ${procurementMethodType}=   Get From Dictionary    ${ARGUMENTS[0].data}    procurementMethodType

  ${items}=  Get From Dictionary  ${ARGUMENTS[0].data}   items
  ${items_count}=  Get Length  ${items}
  
  : FOR   ${item_index}  IN RANGE  ${items_count}
  \
  \   # show pop item add
  \   # Wait And Click  xpath=//button[@ng-click="vm.addItem()"] 
  \
  \   Edit Item Basic Data  ${items}  ${item_index}  ${procurementMethodType}
  \
  \   # Set CPV
  \   Edit Item Classificator  ${items}  ${item_index}
  \
  \   # Edit Delivery Address
  \   Add Item Delivery Data  ${items}  ${item_index}
  \
  \   # Edit time start delivery date
  \   Run Keyword If  '${procurementMethodType}' != 'esco'
  \   ...  Edit Item Date  ${items}  ${item_index}
  \
  \   # Add new item
  \   Run Keyword If    ${item_index} < ${NUMBER_OF_ITEMS} - 1   Wait And Click   xpath=//button[@ng-click="vm.addItem()"]
  \   Sleep     2

Edit Item Basic Data
  [Arguments]  ${items}  ${item_index}  ${procurementMethodType}
  ${item_description}=  Get From Dictionary  ${items[${item_index}]}  description
  ${item_quantity_raw}=  Get From Dictionary  ${items[${item_index}]}  quantity
  ${item_quantity}=     convert_quantity          ${item_quantity_raw}
  ${unit_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${items[${item_index}]}  unit
  ${unit}=  Run Keyword If  ${unit_exist}  Get From Dictionary  ${items[${item_index}]}  unit
  ${unit_code}=  Run Keyword If  ${unit_exist}  Get From Dictionary       ${unit}        code
  ${unit_name}=  Run Keyword If  ${unit_exist}  Get From Dictionary       ${unit}        name

  # Short time walk around.
  Input text   id=itemDescription-${item_index}   ${item_description}
  Run Keyword If  ${unit_exist}  Input text  id=quantity-${item_index}  ${item_quantity}

  # if in Item have description english when edit it
  Edit Feasible Element  ${items[${item_index}]}  title_en  Input Text  ${locator.edit_item_title_en}-${item_index}

  # if in Item have description english when edit it
  Edit Feasible Element  ${items[${item_index}]}  description_en  Input Text  ${locator.edit_item_description_en}-${item_index}
  Run Keyword If  '${procurementMethodType}' != 'esco'
  ...  Edit Tender Item Unit Measure  ${item_index}  ${unit_name}

Edit Item Unit Data
  [Arguments]  ${items}  ${item_index}
  
Add Item Delivery Data
  [Arguments]  ${items}  ${item_index}

  ${deliveryaddress}=  Get From Dictionary  ${items[${item_index}]}  deliveryAddress
  ${deliveryaddress_postalcode}=  Get From Dictionary  ${items[${item_index}].deliveryAddress}   postalCode
  ${deliveryaddress_countryname}=  Get From Dictionary  ${items[${item_index}].deliveryAddress}   countryName
  ${deliveryaddress_streetaddress}=  Get From Dictionary  ${items[${item_index}].deliveryAddress}   streetAddress
  ${deliveryaddress_region}=  Get From Dictionary  ${items[${item_index}].deliveryAddress}  region
  ${deliveryaddress_locality}=  Get From Dictionary  ${items[${item_index}].deliveryAddress}  locality

  Fill The Delivery Fields  ${item_index}  ${deliveryaddress_countryname}  ${deliveryaddress_postalcode}  ${deliveryaddress_region}   ${deliveryaddress_locality}   ${deliveryaddress_streetaddress}

# Filling the Delivery info Pop-up
Fill The Delivery Fields
  [Arguments]  ${INDEX}   ${deliveryaddress_countryname}  ${deliveryaddress_postalcode}  ${deliveryaddress_region}   ${deliveryaddress_locality}   ${deliveryaddress_streetaddress}

  # start open popup window
  Focus                 xpath=//input[contains(@id, 'deliveryAddress-${INDEX}')]
  Click Element         xpath=//input[contains(@id, 'deliveryAddress-${INDEX}')]

  # wait popup upload before work
  Wait Until Page Contains Element  xpath=//input[@name="postal-code"]

  # input streat address
  Wait Until Element Is Enabled  xpath=//input[@name="street_address"]
  Focus  xpath=//input[@name="street_address"]
  Input Text  xpath=//input[@name="street_address"]  ${deliveryaddress_streetaddress}

  # input country name
  Wait Until Element Is Enabled  xpath=//*[@id="delivery-country"]
  Focus  xpath=//md-select[@id="delivery-country"]
  Click Element  xpath=//md-select[@id="delivery-country"]
  Wait Until Element Is Visible  xpath=//md-option[@value="${deliveryaddress_countryname}"]
  Click Element  xpath=//md-option[@value="${deliveryaddress_countryname}"]

  # input company city
  Wait Until Element Is Enabled  xpath=//input[@name="company-city"]
  Focus  xpath=//input[@name="company-city"]
  Input Text  xpath=//input[@name="company-city"]  ${deliveryaddress_locality}

  # input region
  Focus          id=delivery-region
  Click Element  id=delivery-region
  Wait Until Element Is Visible  xpath=//md-option[@value="${deliveryaddress_region}"]
  Click Element  xpath=//md-option[@value="${deliveryaddress_region}"]

  # input postal code
  Sleep  1
  Wait Until Element Is Enabled  xpath=//input[@name="postal-code"]
  Input Text  xpath=//input[@name="postal-code"]  ${deliveryaddress_postalcode}

  # save address
  Wait Until Element Is Visible  xpath=//button[@ng-click="vm.save()"]
  Click Element  xpath=//button[@ng-click="vm.save()"]
  Sleep  2

Edit Tender Item Unit Measure
  [Arguments]  ${item_index}  ${unit_name}

  # click to dropdown
  ${locator.measure_name_dropdown}=  Set Variable  xpath=//div[@id="item-${item_index}"]//a[@id="measure-list"]
  ${new_focus}=  Set Variable  xpath=//label[@for="start-date-delivery0"]
  Focus  ${new_focus}
  Wait And Click  ${locator.measure_name_dropdown}

  # click to element
  Sleep  2
  ${measure_name}=  Get Webelements  xpath=//a[@id="measure-list"]/..//a[contains(text(), '${unit_name}')]
  Focus  ${measure_name[-1]}
  Click Element  ${measure_name[-1]}
  Sleep  1
  #${locator.measure_name}=  Set Variable  xpath=//div[@id="item-${item_index}"]//a[contains(text(), '${unit_name}')]
  #Wait And Click  ${locator.measure_name}

Edit Item Classificator
  [Arguments]  ${items}  ${item_index}

  ${classification_id}=  Get From Dictionary       ${items[${item_index}].classification}    id
  ${classification_description}=  Get From Dictionary       ${items[${item_index}].classification}    description
  ${classification_scheme}=  Get From Dictionary       ${items[${item_index}].classification}    scheme

  Focus                              id=classifier-cpv-${item_index}
  Wait Until Page Contains Element   id=classifier-cpv-${item_index}
  Click Element                      id=classifier-cpv-${item_index}
  Wait And Type  id=classifier-search-field   ${classification_id}
  Wait And Click  xpath=//span[contains(text(),'${classification_id}')]
  Wait And Click  id=select-classifier-btn

Edit Item Date
  [Arguments]  ${items}  ${item_index}
  # Edit time start delivery date
  ${locator.item_start_date}=  Set Variable  xpath=//input[@id="input-date-item-deliveryDate-startDate${item_index}"]
  ${deliverydate_start_date}=  Get From Dictionary  ${items[${item_index}].deliveryDate}  startDate
  Set Date Time  ${locator.item_start_date}  ${deliverydate_start_date}

  # Edit time start delivery date
  ${locator.item_end_date}=  Set Variable  xpath=//input[@id="input-date-item-deliveryDate-endDate${item_index}"]
  ${deliverydate_end_date}=  Get From Dictionary  ${items[${item_index}].deliveryDate}  endDate
  Set Date Time  ${locator.item_end_date}  ${deliverydate_end_date}
