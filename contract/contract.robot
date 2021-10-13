*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Choise contract
  [Arguments]    @{ARGS}
  ${contract_item}=  Set Variable  ${ARGS[0]}

Confirm contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Confirm contract

  # confirm contract
  Wait And Type  xpath=button[@id="finish-contract-btn"]

  # click to button save
  Wait And Type  xpath=//button[@ng-click="save()"]

  # singup contract
  SingUp Contract

  # finish contract
  Wait And Type  xpath=//button[@ng-click="terminateContract()"]

Decline contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Decline contract

  ${locator.button_decline}=  Set Variable  xpath=//button[@id="terminate-contract-btn"]
  Wait And Click  ${locator.button_decline}

  # need why you decline
  ${locator.button_decline_description}=  Set Variable  xpath=//input[@name="terminationDetails"]
  Wait And Type  ${locator.button_decline_description}  decline bid why

  # click to button save
  Wait And Click  xpath=//button[@ng-click="save()"]

  # Sing up button
  SingUp Contract

  Wait And Click  xpath=//button[@ng-click="terminateContract()"]

Change contract
  [Arguments]    @{ARGS}
  Print Args  @{ARGS}
  Log To Console  [+] Change contract

  # open popup edit contract
  Wait And Click  xpath=//button[@ng-click="createChange()"]

  # choise type reason
  ${locator.elements_reason_why_change}=  Set Variable  xpath=//input[@ng-change="collectRationaleTypes()"]
  ${elements_reason}=  Get WebElements  ${locator.elements_reason_why_change}
  Click  ${elements_reason[5]}

  # white reason to change contract
  ${locator.reason_description}=  Set Variable  xpath=//textarea[@ng-model="changes.rationale"]
  Wait And Type  ${locator.reason_description}  my custom rason

  # go to edit
  ${locator.save_reason_and_on}=  Set Variable  xpath=//button[@ng-click="createChange()"]
  Wait And Click  ${locator.save_reason_and_on}

  # wait reload page
  Sleep  5

  # here whould be some variant
  # 1. change price
  # 2. change price with NDS
  # 3. change price by One count

  # after change something
  # save
  ${locator.publish_change_contract}=  Set Variable  xpath=//button[@ng-click="publish(contract)"]
  Wait And Type  ${locator.publish_change_contract}

  # singin contract
  # xpath=//button[@ng-click="sign()"]

  # publick again
  ${locator.publish_change}=  Set Variable  xpath=//button[@ng-click="publicChange()"]
  Wait And Click  ${locator.publish_change}

  # confirm date for publish
  ${locator.confirm_date_publish_change}=  Set Variable  xpath=//button[@ng-click="publicChange(publicData)"]
  Wait And Click  ${locator.confirm_date_publish_change}
