*** Variables ***

# ===== PLAN VIEW =====
${locator.field_search_plan}     xpath=//input[@ng-model="searchData.query"]
${locator.button_search_plan}    xpath=//button[@ng-click="search()"]
${locator.result_plans_list}     xpath=//a[@class="row tender-info ng-scope"]
${page.sarch_plans}              https://dev23.newtend.com/opc/provider/plans/all/?pageNum=1&query=&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=

# plan create action buttons and links
${locator.field_search_plan}    xpath=//input[@ng-model="searchData.query"]
${locator.button_search_plan}    xpath=//button[@ng-click="search()"]
${locator.result_plans_list}    xpath=//a[@class="row tender-info ng-scope"]

# plan basic
${locator.view_plan_type}    xpath=//h4/span[2]
${locator.view_plan_description}    xpath=//div[@id="view-tender-description"]
${locator.view_plan_currenry}    xpath=//div[@ng-bind="plan.budget.currency"]
${locator.view_plan_status}    xpath=//span[@class="status ng-binding"]
# plan customer
${locator.view_plan_customer_name}    xpath=//div[@id="view-customer-name"]
${locator.view_plan_customer_name_scheme}    xpath=//div[@id="view-buyer-code-0"]
${locator.view_plan_customer_name_id}    xpath=//div[@id="view-customer-code"]
${locator.view_plan_customer_legal_name}    xpath=//div[@id="view-customer-name"]
# plan classificator
${locator.view_plan_classification_description}    xpath=//div[@id="plan-classifier"]
${locator.view_plan_classification_scheme}    xpath=//label[contains(., 'ДК 021:2015')]
${locator.view_plan_classification_id}    xpath=//div[@id="plan-classifier"]
#plan item
${locator.view_plan_item_description}    xpath=//div[@id="view-item-description"]
${locator.view_plan_item_quantity}    xpath=//*[@id="quantity"][1]
${locator.view_plan_item_measure_name}    xpath=//*[@class="unit ng-binding"][1]
${locator.view_plan_item_delivery_date}   xpath=//div[@id="start-date-delivery"]
${locator.view_plan_item_classificator_description}    xpath=//div[@id="classifier"]
${locator.view_plan_item_classificator_scheme}    xpath=//label[contains(., 'ДК 021:2015')]
${locator.view_plan_item_classificator_id}    xpath=//div[@id="classifier"]

# ===== PLAN END VIEW =====

# ===== PLAN EDIT =====

${locator.edit_plan_budget_description}         xpath=//input[@id="plan-description"]
${locator.edit_plan_budget_amount}              xpath=//input[@id="budget"]
${locator.edit_plan_item_0_delivery_end_date}   xpath=//input[@id="start-date-delivery0"]
${locator.edit_plan_item_0_quantity}            xpath=//input[@id="quantity0"]
${locator.edit_plan_start_date}                 xpath=//input[@id="input-date-plan-budget-period-startDate"]
${locator.edit_plan_end_date}                   xpath=//input[@id="input-date-plan-budget-period-endDate"]
${locator.edit_plan_item_0_remove}              xpath=//a[@ng-click="removeField($index)"]
${locator.edit_plan_item_add}                   xpath=//a[@ng-click="addField()"]

# project
${locator.edit_plan_project_id}                 xpath=//input[@id="project-id"]
${locator.edit_plan_project_name}               xpath=//input[@id="project-name"]
# ===== PLAN END EDIT =====

# ===== PLAN SEARCH =====

${locator.field_search_plan}    xpath=//input[@ng-model="searchData.query"]
${locator.button_search_plan}    xpath=//button[@ng-click="search()"]
${locator.result_plans_list}    xpath=//a[@class="row tender-info ng-scope"]
${page.sarch_plans}    https://dev23.newtend.com/opc/provider/plans/all/?pageNum=1&query=&status=&procurementMethodType=&amount_gte=&amount_lte=&createReport=&create_gte=&create_lte=&tp_gte=&tp_lte=

# ===== PLAN END SEARCH =====
