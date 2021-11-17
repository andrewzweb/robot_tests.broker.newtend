** Settings ***
Resource  ../tender.robot

*** Keywords ***

Create Esco Tender
  [Arguments]  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_data}=  Set Variable  ${ARGS[1]}

  Log To Console  [.] Creating Create Esco Tender

  ${tender_data}=  overwrite_procuringEntity_data  ${tender_data}
  ${tender_data}=  overwrite_features_values  ${tender_data}
  #${tender_data}=  custom_date  ${tender_data}  0  0  0  0  0  0
  #${tender_data}=  change_minits_for_tests  ${tender_data}  0  5  8  35  36  55

  # Get Plan Id
  Go To Plan And SingUp

  Edit Tender Title and Description  ${tender_data}

  # === It's all in one popup window
  ${locator.edit_lot_first}=  Set Variable  xpath=//input[@id="lot-id-0"]

  # click to add lot
  Wait And Click  ${locator.edit_lot_first}

  #Wait Until Element Is Visible  xpath=//div[@class="container"]/h3

  Add lots  ${tender_data}

  Add Item  ${tender_data}

  #Edit Milestones  ${tender_data}

  Wait And Click  xpath=//button[@ng-click="save()"]

  Sleep  2
  # === It's all in one popup window

  Edit Date For Tender  ${tender_data}

  # for esco
  Edit NBU Count Rate  ${tender_data}

  Edit Features  ${tender_data}

  Edit Language Contract

  Edit MainProcurementCategory  ${tender_data}

  Edit Date For Tender  ${tender_data}

  Publish tender

  Choise Dont Add Document

  SingUp Tender

  ${tender_data}=  Edit Supplement Criteria New  ${tender_data}

  Make Global Variable  ${username}  ${tender_data}

  Log To Console  Global Tender  ${g_data.current_tender_id}

  Run Keyword And Return  Set Created Tender ID In Global Variable

Edit NBU Count Rate
  [Arguments]  ${tender_data}

  # NBUdiscountRate
  ${data.NBUdiscountRate}=  Get From Dictionary   ${tender_data.data}  NBUdiscountRate
  ${data.NBUdiscountRate}=  convert_quantity  ${data.NBUdiscountRate}
  Wait And Type  ${locator.edit_esco_NBUdiscountRate}  ${data.NBUdiscountRate}

  # funding
  ${data.fundingKind}=  Get From Dictionary   ${tender_data.data}  fundingKind
  Select From List By Value  ${locator.edit_esco_fundingKind}  ${data.fundingKind}

Edit Language Contract
  ${locator.contract_language}=  Set Variable  xpath=//select[@id="customer-contact-lang"]
  ${data.contract_language}=  Set Variable  uk
  Focus  ${locator.contract_language}
  Select From List By Value  ${locator.contract_language}  ${data.contract_language}
