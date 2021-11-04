** Settings ***
Resource  ../plan/plan_locators.robot

*** Variables ***
${locator.title}                     id=tender-title
${locator.view_title}                id=view-tender-title
${locator.description}               id=tender-description
${locator.view_description}          id=view-tender-description
${locator.edit.description}          name=tenderDescription
${locator.value.amount}              xpath=//*[@id="budget"]
${locator.view_value_amount}         id=view-tender-value

# tender budget

${locator.view_tender_budget_value_amount}  xpath=//span[@id="tender_budget_value_amount"]
${locator.view_tender_budget_value_currency}  xpath=//span[@id="tender_budget_value_currency"]
${locator.view_tender_budget_value_valueAddedTaxIncluded}  xpath=//span[@id="tender_budget_value_valueAddedTaxIncluded"]

${locator.minimalStep.amount}        xpath=//div[@ng-bind="tender.minimalStep.amount"]
${locator.tenderId}                  xpath=//a[@class="ng-binding ng-scope"]
${locator.procuringEntity.name}      xpath=//div[@ng-bind="tender.procuringEntity.name"]
${locator.enquiryPeriod.StartDate}   id=start-date-enquiry      # New name for tenders
${locator.enquiryPeriod.endDate}     id=end-date-enquiryPeriod  # New name for tenders
${locator.tenderPeriod.startDate}    id=start-date-enquiry      # New name for tenders
${locator.tenderPeriod.endDate}      id=end-date-tenderPeriod   # New name for tenders
${locator.items[0].deliveryAddress}                             id=deliveryAddress
${locator.items[0].deliveryDate.endDate}                        id=end-date-delivery
${locator.items[0].description}                                 xpath=//div[@ng-bind="item.description"]
${locator.items[0].classification.scheme}                       id=classifier
${locator.items[0].classification.scheme.title}                 xpath=//label[contains(., "Классификатор CPV")]
${locator.items[0].additional_classification[0].scheme}         id=classifier2
${locator.items[0].additional_classification[0].scheme.title}   xpath=//label[@for="classifier2"]
${locator.items[0].quantity}                                    id=quantity
${locator.items[0].unit.name}                                   xpath=//span[@class="unit ng-binding"]
${locator.edit_tender}     id=edit-tender-btn
${locator.edit.add_item}   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
${locator.save_tender}     xpath=//button[@id="submit-btn"]
${locator.QUESTIONS[0].title}         xpath=//span[@class="user ng-binding"]
${locator.QUESTIONS[0].description}   xpath=//span[@class="question-description ng-binding"]
${locator.QUESTIONS[0].date}          xpath=//span[@class="date ng-binding"]

${locator.e_logo}       xpath=//a[@ui-sref="goHome"]

# negotiation locators
${locator.cause_descr}      id=tender-cause-description

# ==================
${locator.feature_main}     id=qualityIndicator
${locator.lot_main}         id=lot
${locator.lot_relation}     id=itemLot0
${locator.lot_title}        id=title0   # Need to use ${ARGUMENTS[x]} as lot identifier number
${locator.lot_description}  id=description0
${locator.lot_budget}       id=budget0
${locator.lot_step}         id=step0
${locator.lot_add}          id=add-lot-0
${locator.lot_save}         xpath=//button[@ng-click="save()"]

# Locators for reporting Participant add
${locator.supplier_company_name}    id=short-name
${locator.supplier_legal_name}      id=legalName
${locator.supplier_country}    id=view-country
${locator.supplier_url}        id=uri
${locator.supplier_phone}      id=telephone
${locator.supplier_name}       id=name
${locator.supplier_email}      id=email
${locator.supplier_zip}        id=postalCode
${locator.supplier_region}     id=view-region
${locator.supplier_locality}   id=locality
${locator.supplier_streetAddress}   id=streetAddress
${locator.supplier_ua-id}      id=ua-id

# View locators
${locator.view_country}     xpath=//span[@ng-if="tender.procuringEntity.address.countryName"]
${locator.view_locality}    xpath=//span[@ng-if="tender.procuringEntity.address.locality"]
${locator.view_zip}         xpath=//span[@ng-if="tender.procuringEntity.address.postalCode"]
${locator.view_region}      xpath=//span[@ng-if="tender.procuringEntity.address.region"]
${locator.view_street}      xpath=//span[@ng-if="tender.procuringEntity.address.streetAddress"]
${locator.view.procuringEntity.name}    xpath=//div[@class="block-info__text block-info__text--big block-info__text--bold ng-binding"]


