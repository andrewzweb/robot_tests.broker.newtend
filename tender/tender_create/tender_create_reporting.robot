** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Reporting Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Tender Reporting
  #${init_tender_data}=  overwrite_procuringEntity_data_for_owner  ${tender_data}
  #${init_tender_data}=  Get From Dictionary  ${init_tender_data}  data
  #Set Global Variable  ${USERS.users['${tender_owner}'].initial_data}  ${init_tender_data}

  Go To   ${url.tender_reporting}

  Edit Tender Title and Description  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Edit Budget In BelowThreshold  ${tender_data}

  ${status_criteria_exist}=  Exist key in dict  ${tender_data.data}  criteria
  Run Keyword If  ${status_criteria_exist}  Edit Guarentee  ${tender_data}
  Run Keyword If  ${status_criteria_exist}  Edit Criteria  ${tender_data}

  Publish tender

  Choise Dont Add Document

  Run Keyword  SingUp Tender

  Log To Console  [+] Create Tender with criteria

  Run Keyword And Return  Set Created Tender ID In Global Variable



