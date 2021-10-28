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
