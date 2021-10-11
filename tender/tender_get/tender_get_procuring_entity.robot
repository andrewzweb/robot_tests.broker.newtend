*** Keywords ***

Отримати інформацію про procuringEntity.address.countryName
# Reporting procedure - country
  ${customer_country}=  отримати текст із поля і показати на сторінці   view_country
  ${c_country}=     Get Substring   ${customer_country}     0     -1
  [Return]  ${c_country}

Отримати інформацію про procuringEntity.address.locality
# Reporting procedure - city
  ${customer_locality}=     отримати текст із поля і показати на сторінці   view_locality
  ${c_locality}=    Get Substring   ${customer_locality}    0    -1
  [Return]  ${c_locality}

Отримати інформацію про procuringEntity.address.postalCode
# Reporting procedure - zip
  ${customer_zip}=      отримати текст із поля і показати на сторінці    view_zip
  ${c_zip}=     Get Substring   ${customer_zip}     0   -1
  [Return]  ${c_zip}

Отримати інформацію про procuringEntity.address.region
# Reporting procedure - region oblast
  ${customer_region}=   отримати текст із поля і показати на сторінці   view_region
  ${c_region}=      Get Substring   ${customer_region}  0   -1
  [Return]  ${c_region}

Отримати інформацію про procuringEntity.address.streetAddress
# Reporting procedure - street
  ${customer_street}=   отримати текст із поля і показати на сторінці   view_street
  ${c_street}=      Get Substring   ${customer_street}  0
  [Return]   ${c_street}

Отримати інформацію про procuringEntity.contactPoint.name
# Reporting procedure - customer contact name
  ${contact_name}=  Get Webelements    xpath=//div[@class="block-info"]/..//div[@class="block-info__text block-info__text--bold ng-binding"]
  ${name_text}=     Get Text    ${contact_name[-1]}
  [Return]   ${name_text}
Отримати інформацію про procuringEntity.contactPoint.telephone
# Reporting procedure - customer phone
  ${phone_block}=   Get Webelements     xpath=//div[@class="block-info__text ng-binding"]
  ${phone}=         Get Text    ${phone_block[-2]}
  [Return]   ${phone}

Отримати інформацію про procuringEntity.contactPoint.url
  Log To Console  Don't have this functional

Отримати інформацію про procuringEntity.identifier.legalName
# Reporting procedure - official name
  ${official_name}=    Get Text    xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text block-info__text--big block-info__text--bold ng-binding"]
  log to console    off name - ${official_name}
  [Return]   ${official_name}

Отримати інформацію про procuringEntity.identifier.scheme
# Reporting procedure - Customer UA-EDR scheme or like this
  ${lines}=    Get Webelements     xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text ng-binding"]
  ${line}=     Get Text     ${lines[-1]}
  ${scheme}=   Get Substring     ${line}    -6
  [Return]    ${scheme}

Отримати інформацію про procuringEntity.identifier.id
# Reporting procedure - Customer EDR ID
  ${lines}=   Get Webelements     xpath=//div[@class="block-info__title ng-binding"]/..//div[@class="block-info__text ng-binding"]
  ${line}=    Get Text     ${lines[-1]}
  ${id}=      Get Substring     ${line}   0  -8
  [Return]      ${id}
