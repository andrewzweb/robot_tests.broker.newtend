** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Defence Tender aboveThresholdUA
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

Create Defence Tender
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Simple.Defense Tender

  Go To Plan And SingUp

  ${tender_data}=  overwrite_features_values  ${tender_data}
  #${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  #${tender_data}=  change_minits_for_tests  ${tender_data}  0  5  8  35  36  55

  ${locator.button_create_tender_from_plan}=  Set Variable  xpath=//button[@ng-click="createTenderFromPlan()"]
  Wait And Click  ${locator.button_create_tender_from_plan}

  Edit Tender Title and Description  ${tender_data}

  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # === It's all in one popup window
  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  Wait Until Element Is Visible  xpath=//div[@class="container"]/h3

  Add lots  ${tender_data}

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]

  Sleep  2
  # === It's all in one popup window

  #Edit Features  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  #${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable

