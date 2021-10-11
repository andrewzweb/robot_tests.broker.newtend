** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Multilot Tender
  [Arguments]  ${tender_data}
  Log To Console  [+] Create Tender with criteria

  ${tender_data}=  overwrite_procuringEntity_data  ${tender_data}

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

  ${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  ${tender_data}=  Input Custom Date  ${tender_data}

  Run Keyword  SingUp Tender

  Run Keyword And Return  Set Created Tender ID In Global Variable
