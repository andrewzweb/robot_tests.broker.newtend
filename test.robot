*** Settings ***
Library  Collections
Library  BuiltIn
Library  String
Library  OperatingSystem
Resource  newtend.robot

*** Variables ***
&{lots}  id=1  name=SOmeName
&{D1}    a=1


*** Test Cases ***
Get exist key from vocabulary
    ${current_id}=  Get From Dictionary  ${lots}  id 
    Should Be Equal  ${current_id}  1

Custom method get from dict
    ${key}=  Set Variable  id
    ${dict}=  Create Dictionary   id=some_id, name=some_name
    ${result}=  Exist key in dict  ${dict}  ${key}
    Should Be True  ${result} == True

Get Dict inside
    ${result}=  Get From Dictionary  ${lots.other_dict}  id
    Should be True inside_id == ${result}

Work service func human like
    Set To Dictionary  ${D1}  b=2
    Log To Console  ${D1}

Change date
    ${some_date}=  Set Variable  2021-09-04T19:57:00.763813+03:00 
    ${result}=  plus_count_day_to_date  ${some_date}  2

    Log To Console  Some ${some_date}
    Log To Console  Result ${result}

Get Current Date Obj
    ${some_date}=  Set Variable  2021-09-13T11:13:31.355339+03:00
    ${date_now}=  convert_string_date_to_obj  ${some_date}
    Log To Console  Date Obj: ${date_now}

Get Current Date Obj Other Date
    ${some_date}=  Set Variable  2021-09-13T00:00:00+03:00
    ${date_now}=  change_count_day_to_date  ${some_date}  30
    Log To Console  Date Obj: ${date_now}

Get Current Date
    ${date_now}=  get_now_date
    Log To Console  Date: ${date_now}

Current Date Plus Count Minit
    ${one}=  date_now_plus_minutes  1
    Log To Console  Date: ${one}
    ${ten}=  date_now_plus_minutes  10
    Log To Console  Date: ${ten}

Cycle Count
  ${count_of_criteria}=  Convert To Integer  10

  : FOR   ${item}   IN RANGE  ${count_of_criteria}
  \  ${numb}=  Evaluate  ${item}
  \  Log To Console  Criteria ${numb}

Get Tender
  ${tender}=  newtend_get_tender  bd861e500f344165bb3ac0b8301292f8
  Log To Console  ${tender}

Get Interanal ID Test
  ${now_url}=  Set Variable  https://autotest.newtend.com/opc/provider/tender/1195c9cda3fd45f6b5afd2df85aa044b/overview
  ${result}=  Get Substring  ${now_url}  -41  -9
  Log To Console  ${result}

Converter
   ${result}=  convert_for_robot  КВАЛІФІКАЦІЯ
   ${should_be}=  Set Variable  active.qualification
   Should Be Equal  ${should_be}  ${result}  msg=convert_for_robot
   Log To Console  SHould be equal [ ${should_be} : ${result} ]

*** Keywords ***

Exist key in dict
  [Arguments]  ${dict}  ${key}
  ${if_key_in_dict}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${dict}  ${key}
  [Return]  ${if_key_in_dict}


