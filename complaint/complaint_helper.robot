** Settings ***
Resource  ../newtend.robot


Get Complaint Data From Cancelled And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10

  ${api_complaint_cancellation_data}=  api_get_complaint_from_cancellation  ${data.tender_internal_id}
  Log To Console  ${api_complaint_cancellation_data}
  # convert complaint data
  ${complaint}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_complaint_cancellation_data}
  # add token
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_data=${complaint}

  [Return]  ${complaint}


Get Complaint New Data And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -98  -66

  # get complaint data from api
  ${api_complaint_data}=  api_get_complaint  ${data.tender_internal_id}
  # convert complaint data
  ${complaint}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_complaint_data[0]}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
  # convert complaint put in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_data=${complaint}
  [Return]  ${complaint}


Get Cancellation Data And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -41  -9

  ${api_cancellation_data}=  api_get_cancellation  ${data.tender_internal_id}
  Log To Console  ${api_cancellation_data}
  # convert complaint data
  ${cancellation}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_cancellation_data}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  cancellation_data=${cancellation}

  [Return]  ${cancellation}


Get Complaint Data And Put In Global
  [Arguments]  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}

  ${tedner_internal_id}=  Custom Get Internal ID  -42  -10

  # get complaint data from api
  ${api_complaint_data}=  api_get_complaint  ${data.tender_internal_id}
  # convert complaint data
  ${complaint}=  op_robot_tests.tests_files.service_keywords.Munchify  ${api_complaint_data[0]}
  # add complaint token in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
  # convert complaint put in global
  Set To Dictionary  ${USERS.users['${username}']}  complaint_data=${complaint}
  [Return]  ${complaint}
