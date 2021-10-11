** Settings ***
Resource  ./data.robot

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
  [Arguments]  ${locator}  ${value}
  Wait Until Page Contains Element  ${locator}
  Wait Until Element Is Enabled  ${locator}
  Focus  ${locator}
  Input Text  ${locator}  ${value}

Wait And Click
  [Arguments]  ${locator}
  Wait Until Element Is Enabled  ${locator}  20
  Focus  ${locator}
  Wait Until Element Is Visible  ${locator}  20
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

Go To Auction
  Wait And Click  xpath=//a[@ui-sref="tenderView.auction"]

Go To Document Of Tender
  Wait And Click  xpath=//a[@ui-sref="tenderView.documents"]

Go To Questions Of Tender
  Wait And Click  xpath=//a[@ui-sref="tenderView.chat"]

Go To Complains Of Tender
  Wait And Click  xpath=//a[@ui-sref="tenderView.complaint"]

Go To Contracts
  Wait And Click  xpath=//a[@ui-sref="tenderView.contracts()"]

Go To Edit Tender
    Wait And Click  xpath=//a[@id="edit-tender-btn"]
  
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
