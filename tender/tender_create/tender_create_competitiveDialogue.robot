** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create CompetitiveDialogueEU Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Create CompetitiveDialogueEU Tender

  ${tender_data}=  overwrite_procuringEntity_data  ${tender_data}
  ${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  ${tender_data}=  change_minits_for_tests  ${tender_data}  0  8  8  45  45  60

  # Get Plan Id
  Go To Plan And SingUp
  #SingUp Plan

  Wait And Click  ${locator.button_create_tender_from_plan}

  #Edit Argeement Duration  ${tender_data}

  #Edit Features  ${tender_data}

  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  #Wait Until Element Is Visible  xpath=//div[@class="container"]/h3

  Add lots  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]

  Sleep  2
  # === It's all in one popup window

  Edit NDS  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Edit MainProcurementCategory  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable

  #SingUp Tender

# TODO add select choiser nota goods maybe service
# TODO change data tender period chould be 30 days and more
# TODO change data tender date in item should be more tender period
Create CompetitiveDialogueUA Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Create CompetitiveDialogueUA Tender

  ${tender_data}=  overwrite_procuringEntity_data  ${tender_data}
  #${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  #${tender_data}=  change_minits_for_tests  ${tender_data}  0  5  8  11  12  14

    # Get Plan Id
  Go To Plan And SingUp

  Wait And Click  ${locator.button_create_tender_from_plan}

  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  Add lots  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]

  Sleep  2
  # === It's all in one popup window

  Edit NDS  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Edit MainProcurementCategory  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable

