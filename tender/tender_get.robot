** Settings ***
Resource  ./tender_get/tender_get_award.robot
Resource  ./tender_get/tender_get_delivery.robot
Resource  ./tender_get/tender_get_funders.robot
Resource  ./tender_get/tender_get_lot.robot
Resource  ./tender_get/tender_get_milestone.robot
Resource  ./tender_get/tender_get_procuring_entity.robot
Resource  ./tender_get/tender_get_items.robot

*** Keywords ***

Отримати інформацію про status
  # for auction: active.enquiries
  # for qualification
  ${tenderStatus}=  Get Text  xpath=//span[@class="status ng-binding ng-scope"]
  Reload Page
  ${result}=  convert_for_robot  ${tenderStatus}
  Log To Console  [ ] Tender status : ${tenderStatus} robot ${result} 
  Sleep  2
  [Return]  ${result}

Отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  Sleep  1
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [Return]  ${return_value}

Отримати інформацію із description
  [Arguments]    ${field_id}
  [Documentation]
  ...       ${field_id} == field_number
  Sleep     1
  ${item_block}=    Get Webelement  xpath=//h2[contains(., '${field_id}')]
  Focus             ${item_block}
  Click Element     ${item_block}
  Sleep     1
  ${item_description}=  Get Text  ${locator.view_item_description}
  [Return]    ${item_description}

Отримати інформацію про items[0].description
  Sleep  3
  ${item_description}=  Get Text  ${locator.view_item_description}
  [Return]    ${item_description}

Отримати інформацію із classification.scheme
  [Arguments]    @{arguments}
  ${cpvs}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[contains(., '021:2015')]    # /..//div[@class="block-info"]/..//div[@class="block-info__text ng-binding"]
  ${cpv}=    Get Text    ${cpvs[2]}
  ${scheme}=  convert_for_robot  ${cpv}
  [Return]   ${scheme}

Отримати інформацію із classification.id
  [Arguments]    @{arguments}
  ${cpvs}=       Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${class_id}=   Get Text        ${cpvs[2]}
  ${class_id}=   Get Substring   ${class_id}   0   10
  [Return]       ${class_id}

Отримати інформацію із classification.description
  [Arguments]    @{arguments}
  ${cpvs}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${class_description}=  Get Text   ${cpvs[2]}
  ${class_description}=  Get Substring   ${class_description}  13
  [Return]       ${class_description}

Отримати інформацію із additionalClassifications.scheme
  [Arguments]    @{arguments}
  ${dkpps}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[contains(., 'ДКПП')]
  ${dkpp}=    Get Text      ${dkpps[2]}
  ${dkpp_scheme}=   convert_for_robot  ${dkpp}
  log to console    DKPP Scheme - ${dkpp_scheme}
  [Return]      ${dkpp_scheme}

Отримати інформацію із additionalClassifications.id
  [Arguments]    @{arguments}
  ${dkpps}=      Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${dkpp_id}=    Get Text        ${dkpps[3]}
  ${dkpp_id}=    Convert To String   ${dkpp_id.split('${SPACE}-${SPACE}')[0]}
  Log to console    DKPP ID text - ${dkpp_id}
  [Return]       ${dkpp_id}

Отримати інформацію із additionalClassifications.description
  [Arguments]    @{arguments}
  ${dkpps}=      Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${dkpp_id}=    Get Text        ${dkpps[3]}
  ${dkpp_descr}=    Convert To String   ${dkpp_id.split('${SPACE}-${SPACE}')[1]}
  [Return]      ${dkpp_descr}

Отримати інформацію із quantity
# Convert to Integer
  [Arguments]   @{arguments}
  ${quantity}=   Get Text   xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//span[@ng-bind="vm.item.quantity"]
  ${quantity}=   Convert To Integer   ${quantity}
  [Return]      ${quantity}

Отримати інформацію із unit.name
  [Arguments]   @{arguments}
  ${unit_name}=    Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//span[@class="unit ng-binding"]
  log to console   unit name - ${unit_name}
  ${unit_name}=  convert_for_robot  ${unit_name}
  [Return]      ${unit_name}

Отримати інформацію із unit.code
  [Arguments]   @{arguments}
  Log To Console  Don't have this functional

Отримати інформацію про causeDescription
  ${cause_description}=     Get Text    xpath=//div[@class="tender-causes__cause block-info"]/..//div[@ng-bind="tender.causeDescription"]
  [Return]      ${cause_description}

Отримати інформацію про cause
  ${cause_raw}=    Get Text    xpath=//div[@class="tender-causes__cause block-info"]/..//div[@id="view-tender-reasons"]
  ${cause}=  convert_for_robot  ${cause_raw}
  [Return]  ${cause}

Отримати інформацію про contracts[0].status
  Go To Contracts
  Wait Until Page Contains Element  xpath=//div[@class="status ng-binding"]
  ${contract_status}=   Get Text   xpath=//div[@class="status ng-binding"]
  ${status}=    convert_to_human_like_data   ${contract_status}
  [Return]  ${status}

Отримати інформацію про title
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     2
  ${title}=   отримати текст із поля і показати на сторінці   view_title
  [Return]  ${title}

Отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   view_description
  [Return]  ${description}

Отримати інформацію про tenderId
  ${tenderId}=   отримати текст із поля і показати на сторінці   tenderId
  [Return]  ${tenderId}

Отримати інформацію про budget.amount
  ${budget_amount_raw}=   Get Text  xpath=//div[@ng-bind="plan.budget.amount"]
  ${budget_amount}=     Convert To Number   ${budget_amount_raw}
  [Return]  ${budget_amount}

# tender budget data

Отримати інформацію про value.amount
  ${amount_raw}=  Get Text  ${locator.view_tender_budget_value_amount}
  ${result}=  Convert Budget Amount In Number  ${amount_raw}
  [Return]  ${result}

Отримати інформацію про value.currency
  ${currancy_raw}=  Get Text  ${locator.view_tender_budget_value_currency}
  ${result}=    Convert To String  ${currancy_raw}  
  [Return]  ${result}

Отримати інформацію про value.valueAddedTaxIncluded
  ${tax_raw_string}=    Get Text  ${locator.view_tender_budget_value_valueAddedTaxIncluded}
  ${result}=  convert_to_human_like_data  ${tax_raw_string}
  [Return]  ${result}

Отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [Return]  ${minimalStepAmount}

# procuring

Отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   view.procuringEntity.name
  [return]  ${procuringEntity_name}

# tender dates

Отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=    Get Text     xpath=//div[@id="start-date-enquiry-enquiryPeriod"]/./span[@class="period-date ng-binding"]  # enquiryPeriod.StartDate
  #Log To Console    -==${enquiryPeriodStartDate}==-
  [return]  ${enquiryPeriodStartDate}

Отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=    Get Text     xpath=//div[@id="end-date-enquiryPeriod"]/./span[@class="period-date ng-binding"]
  #Log To Console    -==End date - ${enquiryPeriodEndDate}==-
  [return]  ${enquiryPeriodEndDate}

Отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   Get Text   xpath=//div[@id="start-date-enquiry-tenderPeriod"]/./span[@class="period-date ng-binding"]
  [return]  ${tenderPeriodStartDate}

Отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=     Get Text   xpath=//div[@id="end-date-tenderPeriod"]/./span[@class="period-date ng-binding"]
  [return]  ${tenderPeriodEndDate}
