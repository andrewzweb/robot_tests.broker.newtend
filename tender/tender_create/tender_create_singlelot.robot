** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create SingleLot Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}
  Log To Console  [.] Creating SingleLot Tender

  #${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  ${tender_data}=  change_minits_for_tests  ${tender_data}  60  75  75  90  122  128

  ${tender_data}=  Add Createria To Test Data  ${tender_data}

  Go To   ${url.tender_single_lot}

  Edit Tender Title and Description  ${tender_data}

  Edit Budget In BelowThreshold  ${tender_data}

  Add Item  ${tender_data}

  Edit Choise Category Tender  ${tender_data}

  Edit Milestones  ${tender_data}

  Edit Date For Tender  ${tender_data}

  ${status_criteria_exist}=  Exist key in dict  ${tender_data.data}  criteria
  Run Keyword If  ${status_criteria_exist}  Edit Guarentee  ${tender_data}
  Run Keyword If  ${status_criteria_exist}  Edit Criteria  ${tender_data}
  
  Publish tender

  Choise Dont Add Document

  Edit Supplement Criteria New  ${tender_data}

  SingUp Tender

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable
