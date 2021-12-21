** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create OpenEU Tender
  [Arguments]  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}
  Log To Console  [.] Creating OpenUA Tender

  Go To Plan And SingUp

  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  Wait Until Element Is Visible  xpath=//div[@class="container"]/h3
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

  #${tender_data}=  Add Createria To Test Data  ${tender_data}
  #Edit Criteria  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable

Create OpenUA Tender
  [Arguments]  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating OpenUA Tender

  Go To Plan And SingUp

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

  Edit NDS  ${tender_data}

  ${bool_features_exist}=  Exist key in dict  ${tender_data.data}  features
  Run Keyword If  ${bool_features_exist}  Edit Features  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}
  
  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable
