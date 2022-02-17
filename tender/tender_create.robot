** Settings ***
Resource  ./tender_create/tender_create_funders.robot
Resource  ./tender_create/tender_create_reporting.robot
Resource  ./tender_create/tender_create_defence.robot
Resource  ./tender_create/tender_create_multilot.robot
Resource  ./tender_create/tender_create_openua_and_openeu.robot
Resource  ./tender_create/tender_create_singlelot.robot
Resource  ./tender_create/tender_create_negotiation.robot
Resource  ./tender_create/tender_create_closeFrameworkAgreementUA.robot
Resource  ./tender_create/tender_create_competitiveDialogue.robot
Resource  ./tender_create/tender_create_esco.robot

*** Keywords ***

Create Tender
  [Arguments]  @{ARGUMENTS}

  ${username}=     Set Variable  ${ARGUMENTS[0]}
  ${tender_data}=  Set Variable  ${ARGUMENTS[1]}
  ${exist_3_variable}=  Run Keyword And Return Status  Set Variable  ${ARGUMENTS[2]}
  ${plan_id}=  Run Keyword If  ${exist_3_variable}  Set Variable  ${ARGUMENTS[2]}

  ${tender_type}=   Get From Dictionary    ${tender_data.data}    procurementMethodType
  # check tender multilots or not
  ${if_key_in_dict}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  lots

  # Routing to correct type tender
  Run Keyword If  '${tender_type}' == 'belowThreshold' and ${if_key_in_dict} == False  Create SingleLot Tender  @{ARGUMENTS}
  # tender negotiation
  Run Keyword If   '${tender_type}' == 'reporting'  Create Reporting Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'aboveThresholdEU'  Create OpenEU Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'aboveThresholdUA'  Create OpenUA Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'negotiation'  Create Negotiation Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'simple.defense'  Create Defence Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'aboveThresholdUA.defense'  Create Defence Tender aboveThresholdUA  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'closeFrameworkAgreementUA'  Create Framework Agreement Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'belowThreshold' and ${if_key_in_dict}  Create Funders Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'competitiveDialogueEU'  Create CompetitiveDialogueEU Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'competitiveDialogueUA'  Create CompetitiveDialogueUA Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'esco'  Create Esco Tender  @{ARGUMENTS}
  Run Keyword If   '${tender_type}' == 'closeFrameworkAgreementSelectionUA'  Create CloseFrameworkAgreementSelectionUA  @{ARGUMENTS}

  ${id}=  Set Variable  ${g_data.current_tender_id}
  Log To Console  [+] Create Tender ID: ${id}
  [Return]  ${id}





