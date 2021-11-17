** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Negotiation Tender
  [Arguments]  @{ARGS}
  Print Args  @{ARGS}
  ${username}=     Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Negotiation Tender

  # === prepare ====
  Go To Plan And SingUp


  # === creating ===
  Edit Tender Title and Description  ${tender_data}

  Edit Cause  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  Wait Until Element Is Visible  xpath=//div[@class="container"]/h3

  #Add lots  ${tender_data}

  # In test data dont have lot
  # === In UI lot exist ====
  ${data.lot_price}=  Get From Dictionary  ${tender_data.data.value}  amount
  ${data.lot_price}=  Convert To Integer  ${data.lot_price}
  Wait And Type  ${locator.edit_lot_amount}  ${data.lot_price}
  
  ${data.lot_description}=  Get From Dictionary  ${tender_data.data}  description
  Wait And Type  ${locator.edit_lot_description}  ${data.lot_description}
  # =======================

  Add Item  ${tender_data}

  Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]
  # === It's all in one popup window

  #Edit Date For Tender  ${tender_data}

  Edit NDS Negotiation  ${tender_data}

  Sleep  2

  Publish tender

  Choise Dont Add Document

  Run Keyword And Return  Set Created Tender ID In Global Variable

  Log To Console  Global Tender  ${g_data.current_tender_id}

  SingUp Tender


