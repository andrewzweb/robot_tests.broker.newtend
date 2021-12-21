** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Framework Agreement Tender
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Create Framework Agreement Tender

  Go To Plan And SingUp
  
  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

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

  Edit Argeement Duration  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Run Keyword And Return  Set Created Tender ID In Global Variable
