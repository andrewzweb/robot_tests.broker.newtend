*** Keywords ***

Add lots
  [Arguments]  ${tender_data}

  Log To Console  [+] Add lot
  ${procurementMethodType}=   Get From Dictionary    ${tender_data.data}    procurementMethodType

  # how much lots we have
  ${lots}=  Get From Dictionary  ${tender_data.data}    lots
  ${count_lots}=  Get length  ${lots}

  : FOR   ${INDEX}  IN RANGE   ${count_lots}
  \   ${lots}=  Get From Dictionary  ${tender_data.data}  lots
  \
  \   # title
  \   ${lots_title}=  Get From Dictionary  ${lots[${INDEX}]}  title
  \   Wait And Type  ${locator.edit_lot_title}  ${lots_title}
  \
  \   # title en
  \   Edit Feasible Element  ${lots[${INDEX}]}  title_en  Input Text  ${locator.edit_lot_title_en}
  \
  \   # description
  \   ${lots_description}=      Get From Dictionary      ${lots[${INDEX}]}               description
  \   Wait And Type  ${locator.edit_lot_description}  ${lots_description}
  \
  \   # description en
  \   Edit Feasible Element  ${lots[${INDEX}]}  description  Input Text  ${locator.edit_lot_description_en}
  \
  \   Edit Lot Value Amount  ${lots[${INDEX}]}
  \
  \   Edit Lot MinimalStep Amount  ${lots[${INDEX}]}
  \
  \   Edit Lot MinimalStepPercentage  ${lots[${INDEX}]}
  \
  \   Edit Lot YearlyPaymentsPercentageRange  ${tender_data}
  \
  \   #Run Keyword If  '${procurementMethodType}' == 'esco'  Edit Lot Guarantee
  \
  \   Run Keyword If    ${INDEX} < ${count_lots} - 1   Wait And Click   xpath=//button[@ng-click="vm.addItem()"]

  Wait And Click  xpath=//button[@ng-click="save()"]

Edit Lot Value Amount
  [Arguments]  ${lot}
  Log To Console  [+] Edit Lot Value Amount
  # amount (update for esco procedure)
  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${lot.value}  amount
  ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${lot.value}  amount
  ${valid_lot_amount}=    Run Keyword If  ${key_exist}  convert_budget  ${data_key}
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator.edit_lot_amount}
  Run Keyword If  ${key_exist} and ${locator_exist}
  ...  Wait And Type  ${locator.edit_lot_amount}  ${valid_lot_amount}

Edit Lot MinimalStep Amount
  [Arguments]  ${lot}
  Log To Console  [+] Edit Lot MinimalStep Amount
  # step
  ${key_exist}=  Run Keyword And Return Status
  ...  Dictionary Should Contain Key  ${lot.minimalStep}   amount
  ${lot_step}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${lot.minimalStep}   amount
  Log To Console  [ ] Lot minimal step ${lot_step}
  ${valid_lot_step}=  Run Keyword If  ${key_exist}  convert_budget  ${lot_step}
  Log To Console  [ ] Lot minimal step after valid ${valid_lot_step}
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator.edit_lot_step}
  Run Keyword If  ${key_exist} and ${locator_exist}  Wait And Type  ${locator.edit_lot_step}  ${valid_lot_step}

Edit Lot MinimalStepPercentage
  [Arguments]  ${lot}
  Log To Console  [+] Edit Lot MinimalStepPercentage
  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${lot}  minimalStepPercentage
  ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${lot}  minimalStepPercentage
  ${data_key}=  Run Keyword If  ${key_exist}  multiply_float_and_return_string  ${data_key}
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator.edit_lot_minimalStepPercentage}
  Run Keyword If  ${key_exist} and ${locator_exist}  Wait And Type  ${locator.edit_lot_minimalStepPercentage}  ${data_key}

Edit Lot YearlyPaymentsPercentageRange
  [Arguments]  ${lot}
  Log To Console  [+] Edit Lot YearlyPaymentsPercentageRange
  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${lot}  yearlyPaymentsPercentageRange
  ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${lot}  yearlyPaymentsPercentageRange
  ${data_key}=  Run Keyword If  ${key_exist}  multiply_float_and_return_string  ${data_key}
  ${locator_exist}=  Run Keyword And Return Status
  ...  Get WebElement  ${locator.edit_lot_yearlyPaymentsPercentageRange}
  Run Keyword If  ${key_exist} and ${locator_exist}
  ...  Wait And Type  ${locator.edit_lot_yearlyPaymentsPercentageRange}  20

Edit Lot Guarantee
  Log To Console  [+] Edit Lot Guarantee
  ${value_dropdown}=  Set Variable  yes  
  Focus  ${locator.edit_guarantee_dropdown_menu}
  Select From List By Value  ${locator.edit_guarantee_dropdown_menu}  ${value_dropdown}

  Wait And Type  ${locator.edit_guarantee_amount}  1000
  ${currency}=  Set Variable  UAH
  Select From List By Value  ${locator.edit_guarantee_currency}  ${currency}

Змінити лот
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  userName
  ...      ${ARGUMENTS[1]} ==  tenderID
  ...      ${ARGUMENTS[2]} ==  lotName
  ...      ${ARGUMENTS[3]} ==  fieldName - value.amount and minimalStep.amount
  ...      ${ARGUMENTS[4]} ==  fieldValue
  Log To Console  [+] Change Lot

  Sleep     2
  # Navigate to tender overview
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  # Getting into the edit process
  Click Element     id=edit-tender-btn
  Sleep     2
  # Making changes for lot budget
  Focus     xpath=//input[@id="lot"]
  Sleep     1
  Click Element  xpath=//input[@id="lot"]
  Sleep     2
  Focus     xpath=//ng-form[@name="lotForm"]
  Sleep     2
  Run Keyword If    '${ARGUMENTS[3]}' == 'value.amount'         Edit lot budget     ${ARGUMENTS[2]}     ${ARGUMENTS[4]}
  Run Keyword If    '${ARGUMENTS[3]}' == 'minimalStep.amount'   Edit lot step       ${ARGUMENTS[2]}     ${ARGUMENTS[4]}
  Sleep     2
  Click Element  xpath=//button[@ng-click="save()"]
  Sleep     2
  Focus     xpath=//button[@id="submit-btn"]
  Sleep     1
  Click Element     xpath=//button[@id="submit-btn"]
  Sleep     2

Edit lot budget
  [Arguments]   @{arguments}
  Log To Console  [+] Edit lot budget
  # :TODO Seems tobe real hardcode, need to change after FE will make corrections
  ${lot_field}=    Get Webelement     xpath=//div[contains(., '${ARGUMENTS[0]}')]//input[@ng-model="lot.value.amount"]
  Focus     ${lot_field}
  Sleep     2
  Clear Element Text    ${lot_field}
  Sleep     2
  ${value}=     convert_budget     ${ARGUMENTS[1]}
  Input Text    ${lot_field}       ${value}
  Sleep     2

Edit lot step
  [Arguments]   @{arguments}
  Log To Console  [+] Edit lot step
  ${lot_step}=      Get Webelement    xpath=//div[contains(., '${ARGUMENTS[0]}')]//input[@ng-model="lot.minimalStep.amount"]
  Focus     ${lot_step}
  Sleep     2
  Clear Element Text    ${lot_step}
  Sleep     2
  ${value}=     convert_budget     ${ARGUMENTS[1]}
  Input Text    ${lot_step}        ${value}
  Sleep     2
