** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Funders Tender
  [Arguments]  ${tender_data}
  Log To Console  [+] Create Reporting Tender

  Go To  ${url.tender_multilots}

  ${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  ${tender_data}=  change_minits_for_tests  ${tender_data}  0  4  8  14  15  17
  ${tender_data}=  Add Createria To Test Data  ${tender_data}

  Edit Funders  ${tender_data}

  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window

  # click to add lot
  Wait And Click  ${locator.edit_lot_save_form}

  Add lots  ${tender_data}

  Edit Guarentee In Lot  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]
  # === It's all in one popup window

  Edit Date For Tender  ${tender_data}

  Edit Criteria  ${tender_data}

  Publish tender

  Choise Dont Add Document

  Set Created Tender ID In Global Variable

  Edit Supplement Criteria  ${tender_data}

  Make Global Variable  ${tender_data}

  SingUp Tender
