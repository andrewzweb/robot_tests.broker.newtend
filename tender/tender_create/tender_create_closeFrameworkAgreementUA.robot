** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Framework Agreement Tender
  [Arguments]  ${tender_data}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Create Framework Agreement Tender

  ${tender_data}=  overwrite_procuringEntity_data  ${tender_data}
  ${tender_data}=  custom_date  ${tender_data}  0  3  3  6  10  12

  # Get Plan Id
  Go To Plan And SingUp

  Edit Argeement Duration  ${tender_data}
  
  Edit Features  ${tender_data}
  
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

  Publish tender

  Choise Dont Add Document

  Run Keyword And Return  Set Created Tender ID In Global Variable

  Log To Console  Global Tender  ${g_data.current_tender_id}

  SingUp Tender
