*** Settings ***
Resource  ./data.robot

*** Variables ***
${global_log}     True

*** Keywords ***

_Return Element Text
  [Arguments]  ${locator}
  Wait Until Page Contains Element  ${locator}
  ${text}=  Get Text  ${locator}
  [Return]  ${text}

Wait And Change
  [Arguments]  ${locator}  ${value}
  Wait Until Page Contains Element  ${locator}
  Wait Until Element Is Enabled  ${locator}
  Focus  ${locator}
  Input Text  ${locator}  ${value}

Wait And Type
  [Arguments]  ${locator}  ${value}  ${wait_time}=30
  Wait Until Page Contains Element  ${locator}  ${wait_time}
  Wait Until Element Is Enabled  ${locator}  ${wait_time}
  Focus  ${locator}
  Input Text  ${locator}  ${value}

Wait And Click
  [Arguments]  ${locator}  ${wait_time}=30
  Wait Until Element Is Enabled  ${locator}  ${wait_time}
  Focus  ${locator}
  Wait Until Element Is Visible  ${locator}  ${wait_time}
  Click Element  ${locator}

Exist key in dict
  [Arguments]  ${dict}  ${key}
  ${if_key_in_dict}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${dict}  ${key}
  [Return]  ${if_key_in_dict}

Convert Budget Amount In Number
  [Arguments]  ${value}
  ${amount_raw}=  Remove String  ${value}  ${SPACE}
  ${amount_raw}=  Evaluate  '${amount_raw}'.replace(',', '.')
  ${result}=   Convert To Number  ${amount_raw}
  [Return]  ${result}

Edit Feasible Element
  [Arguments]  ${dict}  ${key}  ${keyword}  ${locator}
  ${key_exist}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${dict}  ${key}
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator}
  ${data_key}=  Run Keyword If  ${key_exist}  Get From Dictionary  ${dict}  ${key}
  Run Keyword If  ${key_exist} and ${locator_exist}  ${keyword}  ${locator}  ${data_key}

Go To Overview
  Log To Console  [+] Go to overview
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.overview"]
  Wait Bar Close

Go To Auction
  Log To Console  [+] Go to auction
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.auction"]
  Wait Bar Close

Go To Document Of Tender
  Log To Console  [+] Go to document
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.documents"]
  Wait Bar Close

Go To Questions Of Tender
  Log To Console  [+] Go to question
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.chat"]
  Wait Bar Close

Go To Complaint
  Log To Console  [+] Go to complaint
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.complaint"]
  Wait Bar Close

Go To Contracts
  Log To Console  [+] Go to contract
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.contracts()"]
  Wait Bar Close

Go To Edit Tender
  Log To Console  [+] Go to edit tender
  Wait Bar Open
  Wait And Click  xpath=//a[@id="edit-tender-btn"]
  Wait Bar Close

Go To Prequlification
  Log To Console  [+] Go to prequalification
  Wait Bar Open
  Wait And Click  xpath=//a[@ui-sref="tenderView.prequalification"]
  Wait Bar Close

Go To Create Bid
  # перейти в меню создание бида
  ${locator.button_popup_make_bid}=  Set Variable  xpath=//a[@ui-sref="tenderView.ownBid"]
  Wait And Click  ${locator.button_popup_make_bid}

Print All Date
  [Arguments]  ${tender_data}

  Log To Console  -------- Tender Dates --------
  # tender period
  ${exist_tenderPeriod}=  Exist key in dict  ${tender_data.data}  tenderPeriod

  ${tender_tenderPeriod_startDate}=  Run Keyword If  ${exist_tenderPeriod}  Get From Dictionary  ${tender_data.data.tenderPeriod}  startDate
  Run Keyword If  ${exist_tenderPeriod}  Log To Console  TenderPeriod StartDate: - '${tender_tenderPeriod_startDate}'

  ${tender_tenderPeriod_endDate}=  Run Keyword If  ${exist_tenderPeriod}  Get From Dictionary  ${tender_data.data.tenderPeriod}  endDate
  Run Keyword If  ${exist_tenderPeriod}  Log To Console  TenderPeriod EndDate: --- '${tender_tenderPeriod_endDate}'

  # tender enquiryPeriod
  ${exist_enquiryPeriod}=  Exist key in dict  ${tender_data.data}  enquiryPeriod

  ${tender_enquiryPeriod_startDate}=  Run Keyword If  ${exist_enquiryPeriod}  Get From Dictionary  ${tender_data.data.enquiryPeriod}  startDate
  Run Keyword If  ${exist_enquiryPeriod}  Log To Console  EnquiryPeriod StartDate: '${tender_enquiryPeriod_startDate}'

  ${tender_enquiryPeriod_endDate}=  Run Keyword If  ${exist_enquiryPeriod}  Get From Dictionary  ${tender_data.data.enquiryPeriod}  endDate
  Run Keyword If  ${exist_enquiryPeriod}  Log To Console  EnquiryPeriod EndDate: - '${tender_enquiryPeriod_endDate}'

  Log To Console  -------- End Dates --------

Add Createria To Test Data
  [Arguments]  ${tender_data}
  ${criteria_guarantee_data}=  Підготувати дані по критеріям гарантії  ${criteria_lot}  ${tender_data}
  Set To Dictionary  ${tender_data.data}  criteria=${criteria_guarantee_data.data}
  [Return]  ${tender_data}

Generate Criteria Other
  ${article_17_data}=  Підготувати дані по критеріям статті 17
  [Return]  ${article_17_data}

Generate Criteria LLC
  [Arguments]  ${tender_data}  ${lot}
  ${criteria_lot}=  Run Keyword If  ${lot} == True  Set Variable  True  False
  ${criteria_llc_data}=  Підготувати дані по критеріям життєвого циклу  ${criteria_lot}  ${tender_data}
  [Return]  ${criteria_llc_data}
  
Print Args
  [Arguments]  @{ARGS}
  ${count_items}=  Get Length  ${ARGS}
  : FOR  ${i}  IN RANGE  ${count_items}
  \   Log To Console  ARG[${i}] - ${ARGS[${i}]}

WrapLog
  [Arguments]  ${log_me}
  Run Keyword If  ${global_log} == True  Log To Console  ----------------------------
  Run Keyword If  ${global_log} == True  Log To Console  ${log_me}
  Run Keyword If  ${global_log} == True  Log To Console  ----------------------------

CustomLog
  [Arguments]  ${log_me}
  Run Keyword If  ${global_log} == True  Log To Console  ${log_me}

Wait Bar Open
  Sleep  2
  ${locator.side_bar_panel}=  Set Variable  xpath=//div[@ng-click="$root.toggleSidebar()"]
  Run Keyword And Return Status  Click Element  ${locator.side_bar_panel}
  Sleep  2

Wait Bar Close
  Sleep  2
  ${locator.side_bar_panel}=  Set Variable  xpath=//div[@ng-click="$root.toggleSidebar()"]
  Run Keyword And Return Status  Click Element  ${locator.side_bar_panel}
  Sleep  2

Change Value In Attribute
  [Arguments]  ${attr_value}
  Execute Javascript
  ...  var element=document.querySelector("input[ng-model='item.unit.code']");
  ...  element.setAttribute("value", "${attr_value}");

If Exist Locator Click
  [Arguments]  ${locator}
  ${locator_exist}=  Run Keyword And Return Status  Get WebElement  ${locator}
  ${obj}=  Run Keyword If  ${locator_exist}  Get WebElement  ${locator}
  Run Keyword If  ${locator_exist}  Focus  ${obj}
  Run Keyword If  ${locator_exist}  Sleep  1
  Run Keyword If  ${locator_exist}  Click Element  ${obj}
  Run Keyword If  ${locator_exist}  Sleep  2


JS Wait And Click By Id
  [Arguments]  ${element_id}
  Execute Javascript    window.document.getElementById("${element_id}").click()

Smart Wait
  [Arguments]  @{keyword}

  :FOR  ${index}  IN RANGE  80
  \  Log To Console  [.] Wait ${index}
  \  Sleep  30
  \  Reload Page
  \  ${result}=  Run Keyword And Return Status  ${keyword[0]}  ${keyword[1]}
  \  Exit For Loop IF  ${result} == True

Hide Wallet
  Log To Console  [.] Hide wallet
  Execute Javascript    window.document.getElementById('wallet-menu').style.display = "None";

Get Tender Type
  [Arguments]  ${username}
  ${type}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data}  procurementMethodType
  [Return]  ${type}
