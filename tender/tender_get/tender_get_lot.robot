*** Keywords ***

Отримати лотову інформацію про title
  [Arguments]  ${field_number}
  ${lot_title}=     Get Text    xpath=//span[contains(text(), '${field_number}')]
  [Return]      ${lot_title}

Отримати лотову інформацію про value.amount
  [Arguments]  ${field_number}
  ${lot_value}=     Get Text    xpath=//*[contains(., '${field_number}')]//span[@ng-bind="lot.value.amount"]
  ${lot_value}=     convert_to_float    ${lot_value}
  [Return]      ${lot_value}

Отримати лотову інформацію про minimalStep.amount
  [Arguments]  ${field_number}
  ${lot_step_raw}=      Get Text    xpath=//*[contains(., '${field_number}')]//div[@class="block-info__text block-info__text--bold ng-binding"]
  ${lot_step}=      Get Substring   ${lot_step_raw}   0  -4
  ${lot_step}=      convert_to_float    ${lot_step}
  [Return]      ${lot_step}

Отримати інформацію про lots[0].title
  ${result}=  Get Text  ${locator.view_lots[0].title}
  [Return]  ${result}

Отримати інформацію із lots[0].description
  ${result}=  Get Text  ${locator.view_lots[0].description}
  [Return]  ${result}

Отримати інформацію про lots[0].value.amount
  ${amount_raw}=  Get Text  ${locator.view_lots[0].value.amount}
  ${result}=  Convert Budget Amount In Number  ${amount_raw}
  [Return]  ${result}
Отримати інформацію із lots[0].value.currency
  ${result}=  Get Text  ${locator.view_lots[0].value.currency}
  ${result}=  Convert To String  ${result}
  [Return]  ${result}

Отримати інформацію із lots[0].value.valueAddedTaxIncluded
  ${result}=  Get Text  ${locator.view_lots[0].value.valueAddedTaxIncluded}
  ${result}=  convert_to_human_like_data  ${result}
  [Return]  ${result}

Отримати інформацію про lots[0].minimalStep.amount
  ${result}=  Get Text  ${locator.view_lots[0].minimalStep.amount}
  ${result}=  Convert Budget Amount In Number  ${result}
  [Return]  ${result}

#Отримати інформацію із lots[0].minimalStep.amount
#  ${result}=  Get Text  ${locator.view_lots[0].minimalStep.amount}
#  [Return]  ${result}

#Отримати інформацію із lots[0].minimalStep.currency
#  ${result}=  Get Text  ${locator.view_lots[0].minimalStep.currency}
#  [Return]  ${result}

#Отримати інформацію із lots[0].minimalStep.valueAddedTaxIncluded
#  # don't see this parametr on page
#  ${result}=  Get Text  ${locator.view_lots[0].minimalStep.valueAddedTaxIncluded}
#  [Return]  ${result}
