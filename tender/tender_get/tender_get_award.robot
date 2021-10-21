*** Keywords ***

Отримати інформацію про awards[0].documents[0].title
# Award document title
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     2
  ${award_doc}=     Get Text    xpath=//h3[contains(., 'Qualification protocol')]/..//a[@class="ng-binding"]
  [Return]      ${award_doc}

Отримати інформацію про awards[0].status
# Award user status - winner
  Click Element     xpath=//a[@ui-sref="tenderView.auction"]
  Sleep     2
  ${award_status}=  Get Text   xpath=//span[@ng-if="vm.award.status === 'active'"]
  ${award_status}=  convert_for_robot   ${award_status}
  [Return]  ${award_status}

Отримати інформацію про awards[0].suppliers[0].address.countryName
# Winner Country name
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_country}=    Convert To String   ${address.split(', ')[1]}
  [Return]  ${winner_country}

Отримати інформацію про awards[0].suppliers[0].address.locality
# Winner City
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_city}=   Convert To String   ${address.split(', ')[3]}
  [Return]  ${winner_city}

Отримати інформацію про awards[0].suppliers[0].address.postalCode
# Winner Zip code
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_zip}=   Convert To String   ${address.split(', ')[0]}
  [Return]  ${winner_zip}

Отримати інформацію про awards[0].suppliers[0].address.region
# Winner Oblast
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${winner_region}=   Convert To String   ${address.split(', ')[2]}
  [Return]  ${winner_region}

Отримати інформацію про awards[0].suppliers[0].address.streetAddress
# Winner street
  ${address}=   Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${address}=   Get Text    ${address[-3]}
  ${len_addr}=  Get Length  ${address.split(', ')}
  ${winner_street}=   Convert To String   ${address.split(', ')[4]}
  ${winner_house}=    Convert To String   ${address.split(', ')[5]}
  ${winner_flat}=  Run Keyword If  '${len_addr}' == '7'   Convert To String   ${address.split(', ')[6]}
  ${long_addr}=    Run Keyword If  '${len_addr}' == '7'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}   ${winner_flat}
  ${short_addr}=   Run Keyword If  '${len_addr}' == '6'   Catenate   SEPARATOR=,${SPACE}   ${winner_street}   ${winner_house}
  ${new_address}=  Run Keyword If  '${len_addr}' == '6'   Get Substring   ${short_addr}  0    ELSE   Get Substring   ${long_addr}   0
  [Return]      ${new_address}

Отримати інформацію про awards[0].suppliers[0].contactPoint.telephone
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${phone_number}=  Get Text    ${award_raws[-6]}
  [Return]    ${phone_number}

Отримати інформацію про awards[0].suppliers[0].contactPoint.name
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${name}=    Get Text    ${award_raws[5]}
  [Return]    ${name}

Отримати інформацію про awards[0].suppliers[0].contactPoint.email
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${email}=     Get Text    ${award_raws[-5]}
  [Return]      ${email}

Отримати інформацію про awards[0].suppliers[0].identifier.scheme
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${edr}=     Get Text    ${award_raws[3]}
  [Return]    ${edr}

Отримати інформацію про awards[0].suppliers[0].identifier.legalName
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${legal_name}=    Get Text    ${award_raws[2]}
  [Return]      ${legal_name}

Отримати інформацію про awards[0].suppliers[0].identifier.id
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${id}=      Get Text    ${award_raws[4]}
  [Return]    ${id}

Отримати інформацію про awards[0].suppliers[0].name
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${suppl_name}=    Get Text    ${award_raws[2]}
  [Return]    ${suppl_name}

Отримати інформацію про awards[0].value.valueAddedTaxIncluded
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${vat}=      Get Text    ${award_raws[-1]}
  ${vat_is}=   Get Substring   ${vat}   -9
  ${vat_ready}=  convert_for_robot  ${vat_is}
  [Return]     ${vat_ready}

Отримати інформацію про awards[0].value.currency
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${currancy}=    Get Text    ${award_raws[-1]}
  ${currancy}=    Convert To String     ${currancy.split('${SPACE}')[1]}
  [Return]    ${currancy}

Отримати інформацію про awards[0].value.amount
  ${award_raws}=    Get Webelements    xpath=//div[@class="row v-align"]/..//div[@class="form-control ng-binding"]
  ${amount}=    Get Text    ${award_raws[-1]}
  ${amount}=    Convert To String   ${amount.split('.')[0]}
  ${amount}=    Convert To Integer  ${amount}
  [Return]    ${amount}

Отримати інформацію про awards[0].complaintPeriod.endDate
# Negotiation procedure
  ${period_string}=   Get text    xpath=//div[@ng-if="vm.award.complaintPeriod.endDate"]/.//span[@class="ng-binding"]
  ${raw_period}=      Get Substring   ${period_string}    -19
  ${period}=    get_time_with_offset    ${raw_period}
  [Return]    ${period}

