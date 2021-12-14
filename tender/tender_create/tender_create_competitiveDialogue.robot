** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create CompetitiveDialogueEU Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Create CompetitiveDialogueEU Tender

  # Get Plan Id
  Go To Plan And SingUp

  ${bool_features_exist}=  Exist key in dict  ${tender_data.data}  features
  Run Keyword If  ${bool_features_exist}  Edit Features  ${tender_data}

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

  # Get Plan Id
  Go To Plan And SingUp

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

  ${bool_features_exist}=  Exist key in dict  ${tender_data.data}  features
  Run Keyword If  ${bool_features_exist}  Edit Features  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Edit MainProcurementCategory  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable

