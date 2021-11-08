** Settings ***
Resource  ../../newtend.robot

*** Keywords ***
Aprove Qualification
  [Arguments]    @{ARGS}
  Log To Console  [+] Approve qulification
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${qulification_number}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Go To Prequlification
  Wait Tender Status  active.qualification

  # get data from api
  ${qualification_interanl_id}=  api_get_qulification_id_hesh  ${g_data.current_tender_internal_id}  ${qulification_number}
  Log To Console  [+] Get Internal QUlification ID: ${qualification_interanl_id}

  # collect data from UI
  ${qualification_elements}=  Get WebElements  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]
  ${qualification_count}=  Get Length  ${qualification_elements}
  Log To Console  [i] Count Qualifications: ${qualification_count}

  ${button_accept}=  Set Variable  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]/..//button[@ng-click="decide(qualification.id, true)"]

  :FOR  ${index}  IN RANGE  ${qualification_count}
  \  ${id}=  Set Variable  quality_title_${index}
  \  ${current_qualification_id}=  Get Element Attribute  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]@data-id
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_qualification_id}  ${qualification_interanl_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  Run Keyword If  ${is_need_element} == True      Wait And Click  ${button_accept[${index}]}
  \  Exit For Loop IF  ${is_need_element} == True

  Sleep  2

  ${modal_window}=  Set Variable  xpath=//div[@class="modal-header ng-binding"]
  Wait Until Page Contains Element  ${modal_window}

  ${radio_button_confirm}=  Set Variable  xpath=//input[@name="agree-qualified"]
  Wait Until Page Contains Element  ${radio_button_confirm}
  Select Checkbox  ${radio_button_confirm}

  ${radio_button_article17}=  Set Variable  xpath=//input[@name="agree-eligible"]
  Wait Until Page Contains Element  ${radio_button_article17}
  Select Checkbox  ${radio_button_article17}
  # submit approve
  Wait And Click  xpath=//button[@ng-click="submit()"]

  Sleep  2
  # singup need
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  Sleep  4


Decline Qualification
  [Arguments]    @{ARGS}
  Log To Console  [+] Cancelled qulification

  Print Args  @{ARGS}
  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${qulification_number}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Go To Prequlification
  Wait Tender Status  active.qualification

  # get data from api
  ${qualification_interanl_id}=  api_get_qulification_id_hesh  ${g_data.current_tender_internal_id}  ${qulification_number}
  Log To Console  [+] Get Internal QUlification ID: ${qualification_interanl_id}

  # collect data from UI
  ${qualification_elements}=  Get WebElements  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]
  ${qualification_count}=  Get Length  ${qualification_elements}
  Log To Console  [i] Count Qualifications: ${qualification_count}

  ${button_decline}=  Set Variable  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]/..//button[@ng-click="decide(qualification.id, false)"]

  :FOR  ${index}  IN RANGE  ${qualification_count}
  \  ${id}=  Set Variable  quality_title_${index}
  \  ${current_qualification_id}=  Get Element Attribute  xpath=//div[@ng-repeat="qualification in qualifications track by $index"]@data-id
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_qualification_id}  ${qualification_interanl_id}
  \  Log To Console  [ ] click ${index}? : ${is_need_element}
  \  Run Keyword If  ${is_need_element} == True      Wait And Click  ${button_decline[${index}]}
  \  Exit For Loop IF  ${is_need_element} == True

  # if you decline
  # you should choise reason
  #
  Sleep  2
  ${checkbox_reason_decline}=  Set Variable  xpath=//input[@id="reason2"]
  Wait Until Page Contains Element  ${checkbox_reason_decline}
  Select Checkbox  ${checkbox_reason_decline}

  # And write short description
  Wait And Type  xpath=//textarea[@id="description"]  short decline reason

  # submit approve
  Wait And Click  xpath=//button[@ng-click="submit()"]

  # singup need
  Wait And Click  xpath=//button[@ng-click="vm.sign()"]
  Sleep  5


Cancel Qualification
  [Arguments]    @{ARGS}
  Log To Console  [+] Canceled qulification
  # TODO
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${qulification_number}=  Set Variable  ${ARGS[2]}

  Find Tender By Id  ${tender_id}
  Go To Prequlification
  #Wait Tender Status  'active.qualification'

  ${number}=  Evaluate  ${qulification_number}-1

  ${button_cancelled}=  Set Variable  xpath=//div[@id="qualification_${number}_${number}"]/..//button[@ng-click="cancelDecision(qualification.id)"]
  Wait And Click  ${button_cancelled}
  Sleep  4

Finish Qualification
  [Arguments]    @{ARGS}

  Log To Console  [+] Last approve qulification
  # TODO
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}

  Find Tender By Id  ${tender_id}
  Go To Prequlification
  #Wait Tender Status  'active.qualification'

  ${button_approve}=  Set Variable  xpath=//button[@ng-click="approveQualifications()"]
  Wait And Click  ${button_approve}

  Sleep  7

Get Feature Title
  [Arguments]  ${feature_id}

  ${result}=  Set Variable  0
  ${feature_elements}=  Get WebElements  xpath=//div[@class="tender-feature__title"]
  ${count_features}=  Get Length  ${feature_elements}

  :FOR  ${index}  IN RANGE  ${count_features}
  \  ${id}=  Set Variable  feature_title_${index}
  \  ${current_title}=  Get Text  xpath=//span[@id='${id}']
  \  ${is_need_element}=  is_one_string_include_other_string  ${current_title}  ${feature_id}
  \  Log To Console  [ ] what we looking for ${index}? : ${is_need_element}
  \  ${result}=  Run Keyword If  ${is_need_element} == True   Set Variable  ${current_title}
  \  Exit For Loop IF  ${is_need_element} == True

  [Return]  ${result}

# helper function
Wait Tender Status
  [Arguments]  ${status_should_be}
  Log To Console  [*]  Wait Status
  ${status}=  Wait Until Keyword Succeeds  25 minute  15 seconds  Check Tender Status  ${status_should_be}

# helper function
Check Tender Status
  [Arguments]  ${status_should_be}
  ${done}=  Set Variable  False
  ${current_status}=  Отримати інформацію про status
  Log To Console  [ ] Wait until tender status: ${status_should_be} Now: ${current_status}
  Should Be True  '${status_should_be}' == '${current_status}'
