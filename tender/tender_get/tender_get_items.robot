*** Variables ***
${locator.elements_items_quantity}                 id=quantity
${locator.elements_items_unit_code}                id=classifier
${locator.elements_items_delivery_postal_code}     id=delivery_postal_code
${locator.elements_items_delivery_country_name}    id=delivery_country_name
${locator.elements_items_delivery_region}          id=delivery_region
${locator.elements_items_delivery_adress}          id=delivery_locality
${locator.elements_items_delivery_streetAdress}    id=delivery_streetAddress

*** Keywords ***

Отримати інформацію про items[0].quantity
  ${elements}=  Get WebElements  ${locator.elements_items_quantity}
  ${result}=  Get Text  ${elements}[0]
  [Return]  ${result}

Отримати інформацію про items[0].unit.code
  ${elements}=  Get WebElements  ${locator.elements_items_quantity}
  ${result}=  Get Text  ${elements}[0]
  ${result}=  Get Substring  ${result}  0  10
  [Return]  ${result}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${elements}=  Get WebElements  ${locator.elements_items_delivery_country_name}
  ${result}=  Get Text  ${elements}[0]
  [Return]  ${result}

Отримати інформацію про items[0].deliveryAddress.region
  ${elements}=  Get WebElements  ${locator.elements_items_delivery_region}
  ${result}=  Get Text  ${elements}[0]
  [Return]  ${result}

Отримати інформацію про items[0].deliveryAddress.locality
  ${elements}=  Get WebElements  ${locator.elements_items_delivery_adress}
  ${result}=  Get Text  ${elements}[0]
  [Return]  ${result}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${elements}=  Get WebElements  ${locator.elements_items_delivery_streetAdress}
  ${result}=  Get Text  ${elements}[0]
  [Return]  ${result}
