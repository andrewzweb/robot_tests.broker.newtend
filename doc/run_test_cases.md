
##  2 Single Item Tender

Допороги (Сценарій Single Item Tender містить в собі варіанти виконання для чотирьох ролей (та опціональна provider2, яка виконується майданчиком Quinta):)

### 2.1 tender_owner

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5 -v submissionMethodDetails:"quick(mode:no-auction)"
bin/op_tests -s qualification -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 2.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider -v api_version:2.5 -v submissionMethodDetails:"quick(mode:no-auction)"
bin/op_tests -s qualification -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider -v api_version:2.5

### 2.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider1 -v api_version:2.5 -v submissionMethodDetails:"quick(mode:no-auction)"
bin/op_tests -s qualification -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

### 2.4 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:viewer -v api_version:2.5 -v submissionMethodDetails:"quick(mode:no-auction)"
bin/op_tests -s qualification -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/single_item_tender.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

## 3 Planning		

### 3.1 tender_owner

bin/op_tests -s planning -A robot_tests_arguments/planning.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 3.2 viewer

bin/op_tests -s planning -A robot_tests_arguments/planning.txt -v broker:Newtend -v role:viewer -v api_version:2.5


--------------------

## Розділ 4 Reporting (звітування)		

### 4.1 tender_owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:reporting -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s reporting -A robot_tests_arguments/reporting_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s planning -i create_plan -i find_plan -v MODE:reporting -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s reporting -A robot_tests_arguments/reporting_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

### 5 Below Funders

#### 5.1 tender_owner

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/below_funders.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

#### 5.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/below_funders.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:provider -v api_version:2.5

#### 5.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/below_funders.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

#### 5.3 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/below_funders.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/below_funders.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------
--------------------
--------------------

## 6 OpenEU

### 6.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openeu_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 6.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openeu_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:provider -v api_version:2.5

### 6.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openeu_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

### 6.4 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openeu_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openeu_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

## 7 OpenUA

### 7.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openua_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 7.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openua_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:provider -v api_version:2.5

### 7.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openua_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

### 7.4 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/openua_testing.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/openua_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

## 8 Negotiation

### 8.1 owner 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:negotiation -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s negotiation -A robot_tests_arguments/negotiation_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 8.2 owner 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:negotiation -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s negotiation -A robot_tests_arguments/negotiation_testing.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

## 9 Complaints AMCU

### Скарга на умови тендера, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_tender_declined.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови тендера, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_tender_invalid.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови тендера, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_tender_mistaken.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови тендера, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:
bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_tender_resolved.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови тендера, прийнята до розгляду, зупинена АМКУ:
bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_tender_stopped.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови лота, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_lot_declined.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови лота, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_lot_invalid.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови лота, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_lot_mistaken.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови лота, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_lot_resolved.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на умови лота, прийнята до розгляду, зупинена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_lot_stopped.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на пре-кваліфікацію учасника, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_qualification_declined.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на пре-кваліфікацію учасника, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_qualification_invalid.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на пре-кваліфікацію учасника, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_qualification_mistaken.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на пре-кваліфікацію, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_qualification_resolved.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на пре-кваліфікацію учасника, прийнята до розгляду, зупинена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_qualification_stopped.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на визначення переможця, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_award_declined.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на визначення переможця, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_award_invalid.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на визначення переможця, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_award_mistaken.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на визначення переможця, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_award_resolved.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на визначення переможця, прийнята до розгляду, зупинено АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdUA -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_award_stopped.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_tender_declined.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування тендера, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_tender_invalid.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування тендера, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_tender_mistaken.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування тендера, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_tender_resolved.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування тендера, прийнята до розгляду, зупинено АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_tender_stopped.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування лота, прийнята до розгляду та відхилена АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_lot_declined.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування лота, АМКУ залишив скаргу без розгляду:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_lot_invalid.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування лота, позначена Учасником як помилково створена:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_lot_mistaken.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування лота, прийнята та задоволена АМКУ, Учасником виконано рішення АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_lot_resolved.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### Скарга на скасування лота, прийнята до розгляду, зупинено АМКУ:

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:aboveThresholdEU -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s complaints_new -A robot_tests_arguments/complaint_cancel_lot_stopped.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

--------------------

## 10 Negotiation

### 10.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueUA -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:tender_owner –v api_version:2.5

### 10.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueUA -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider –v api_version:2.5

### 10.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueUA -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider1 –v api_version:2.5

### 10.4 provider2

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueUA -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:provider2 –v api_version:2.5

### 10.5 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueUA -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple_UA.txt -v broker:Newtend –v role:viewer –v api_version:2.5

--------------------

## 11 Competitive Dialogue EU


### 11.1 tender_owner 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueEU -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:tender_owner –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:tender_owner –v api_version:2.5

### 11.1 provider 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueEU -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider –v api_version:2.5

### 11.1 provider1 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueEU -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider1 –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider1 –v api_version:2.5

### 11.1 provider2

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueEU -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider2 –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:provider2 –v api_version:2.5

### 11.1 viewer 

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:competitiveDialogueEU -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s openProcedure –A robot_tests_arguments/competitive_dialogue_simple.txt -v submissionMethodDetails:"quick(mode:no-auction) -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s qualification –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:viewer –v api_version:2.5
bin/op_tests -s contract_signing –A robot_tests_arguments/competitive_dialogue_simple.txt -v broker:Newtend –v role:viewer –v api_version:2.5

--------------------

## 12. ESCO 

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 12.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:esco -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/esco_testing.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Broker
Name -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/esco_testing.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

--------------------

## 13 Framework Agreement

### 13.1 owner

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:closeFrameworkAgreementUA -v broker:Newtend -v role:tender_owner -v
api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/framework_agreement.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v bro
ker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s agreement -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 13.2 provider

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:closeFrameworkAgreementUA -v broker:Newtend -v role:provider -v
api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/framework_agreement.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v bro
ker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s agreement -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider -v api_version:2.5

### 13.3 provider1

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:closeFrameworkAgreementUA -v broker:Newtend -v role:provider1 -v
api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/framework_agreement.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v bro
ker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s agreement -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

### 13.4 provider2

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:closeFrameworkAgreementUA -v broker:Newtend -v role:provider2 -v
api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/framework_agreement.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v bro
ker:Newtend -v role:provider2 -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider2 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider2 -v api_version:2.5
bin/op_tests -s agreement -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:provider2 -v api_version:2.5

### 13.5 viewer

bin/op_tests -s planning -i create_plan -i find_plan -v MODE:closeFrameworkAgreementUA -v broker:Newtend -v role:viewer -v
api_version:2.5
bin/op_tests -s openProcedure -A robot_tests_arguments/framework_agreement.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v bro
ker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s agreement -A robot_tests_arguments/framework_agreement.txt -v broker:Newtend -v role:viewer -v api_version:2.5

--------------------

## 14 Framework Selection

### 14.1 owner

bin/op_tests -s selection -A robot_tests_arguments/framework_selection.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:tender_owner -v api_version:2.5

### 14.2 provider

bin/op_tests -s selection -A robot_tests_arguments/framework_selection.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:provider -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:provider -v api_version:2.5

### 14.3 provider1

bin/op_tests -s selection -A robot_tests_arguments/framework_selection.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:provider1 -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:provider1 -v api_version:2.5

### 14.4 viewer

bin/op_tests -s selection -A robot_tests_arguments/framework_selection.txt -v submissionMethodDetails:"quick(mode:no-auction)" -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s qualification -A rbot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:viewer -v api_version:2.5
bin/op_tests -s contract_signing -A robot_tests_arguments/framework_selection.txt -v broker:Newtend -v role:viewer -v api_version:2.5
