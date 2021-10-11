*** Keywords ***

Отримати інформацію із deliveryLocation.latitude
  [Arguments]   @{arguments}
  Log To Console  Don't have this functional

Отримати інформацію із ddeliveryAddress.countryName_ru
  [Arguments]   @{arguments}
  Log To Console  Don't have this functional

Отримати інформацію із deliveryAddress.countryName_en
  [Arguments]   @{arguments}
  Log To Console  Don't have this functional

Отримати інформацію із deliveryAddress.countryName
# Country name
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${country}=   Convert To String   ${country name.split(', ')[1]}
  [Return]   ${country}

Отримати інформацію із deliveryAddress.postalCode
# Zip code
  [Arguments]   @{arguments}
  ${delivery_zip}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${delivery_zip}=   Get Text   ${delivery_zip[-1]}
  ${zip}=   convert to string  ${delivery_zip.split(', ')[0]}
  [Return]    ${zip}

Отримати інформацію із deliveryAddress.region
# Oblast region
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${region}=    Convert To String   ${country_name.split(', ')[2]}
  [Return]   ${region}

Отримати інформацію із deliveryAddress.locality
  # City
  [Arguments]   @{arguments}
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${locality}=  Convert To String   ${country_name.split(', ')[3]}
  [Return]      ${locality}

Отримати інформацію із deliveryAddress.streetAddress
  [Arguments]   @{arguments}
  # Delivery Address - just street
  ${country_name}=   Get Webelements    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@class="block-info__text ng-binding"]
  ${country_name}=   Get Text    ${country_name[-1]}
  ${len_addr}=       Get Length  ${country_name.split(', ')}
  ${winner_street}=  Convert To String   ${country_name.split(', ')[4]}
  ${winner_house}=   Convert To String   ${country_name.split(', ')[5]}
  ${winner_flat}=   Run Keyword If  '${len_addr}' == '7'   Convert To String   ${country_name.split(', ')[6]}
  ${long_addr}=     Run Keyword If  '${len_addr}' == '7'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}   ${winner_flat}
  ${short_addr}=    Run Keyword If  '${len_addr}' == '6'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}
  ${new_address}=   Run Keyword If  '${len_addr}' == '6'   Get Substring   ${short_addr}  0   -1   ELSE   Get Substring   ${long_addr}   0   -1
  [Return]      ${new_address}

Отримати інформацію із deliveryDate.startDate
  [Arguments]   @{arguments}
  ${delivery_start_date}=     Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@ng-bind="(vm.item.deliveryDate.startDate | date:'yyyy-MM-dd HH:mm:ss')"]
  [Return]   ${delivery_start_date}

Отримати інформацію із deliveryDate.endDate
  [Arguments]   @{arguments}
  ${delivery_end_date}=     Get Text    xpath=//tender-item[contains(., '${ARGUMENTS[0]}')]/..//div[@ng-bind="(vm.item.deliveryDate.endDate | date:'yyyy-MM-dd HH:mm:ss')"]
  [Return]   ${delivery_end_date}
