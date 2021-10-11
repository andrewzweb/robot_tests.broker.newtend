*** Keywords ***

# ========== Funders ==========

Отримати інформацію про funders[0].name
  ${result}=  Get Text  ${locator.view_funders[0].name}
  [Return]  ${result}

Отримати інформацію про funders[0].address.countryName
  ${result}=  Get Text  ${locator.view_funders[0].address.countryName}
  [Return]  ${result}

Отримати інформацію про funders[0].address.locality
  ${result}=  Get Text  ${locator.view_funders[0].address.locality}
  [Return]  ${result}

Отримати інформацію про funders[0].address.postalCode
  ${result}=  Get Text  ${locator.view_funders[0].address.postalCode}
  [Return]  ${result}

Отримати інформацію про funders[0].address.region
  ${result}=  Get Text  ${locator.view_funders[0].address.region}
  [Return]  ${result}

Отримати інформацію про funders[0].address.streetAddress
  ${result}=  Get Text  ${locator.view_funders[0].address.streetAddress}
  [Return]  ${result}

Отримати інформацію про funders[0].identifier.id
  ${result}=  Get Text  ${locator.view_funders[0].identifier.id}
  [Return]  ${result}

Отримати інформацію про funders[0].identifier.legalName
  ${result}=  Get Text  ${locator.view_funders[0].identifier.legalName}
  [Return]  ${result}

Отримати інформацію про funders[0].identifier.scheme
  ${result}=  Get Text  ${locator.view_funders[0].identifier.scheme}
  [Return]  ${result}
