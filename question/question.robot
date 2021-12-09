*** Variables ***
${locator.site_bar_section_question}    xpath=//span[contains(text(), "Уточнения")]
${locator.button_ask_question}          xpath=//button[@ng-if="actions.can_ask_questions"]
${locator.ask_question_field_title}     xpath=//input[@ng-show="chatData.isQuestion"]
${locator.ask_question_field_text}      xpath=//textarea[@ng-model="chatData.message"]
${locator.send_question}                xpath=//button[@ng-click="sendQuestion()"]

${locator.ask_button_answer_to_question}  xpath=//div[@class="answer"]
${locator.ask__field_answer}  xpath=//textarea[@ng-model="chatData.message"]
${locator.ask__send_answer}  xpath=//button[@ng-click="sendAnswer()"]

${locator.ask__tab_question}  xpath=//a[@ui-sref="tenderView.chat"]
${locator.ask__list_of_ask}  xpath=//div[@class="row question-container"]
*** Keywords ***

Ask question
  [Arguments]  ${username}  ${tender_id}  ${question_data}

  Find Tender By Id  ${tender_id}

  Go To Questions Of Tender

  Wait And Click  ${locator.button_ask_question}

  ${title}=        Get From Dictionary  ${question_data.data}  title
  ${description}=  Get From Dictionary  ${question_data.data}  description
  
  Wait And Type   ${locator.ask_question_field_title}   ${title}
  Wait And Type   ${locator.ask_question_field_text}    ${description}

  ${select_questionOf}=  Set Variable  xpath=//select[@ng-model="chatData.questionOf"]
  ${exist_select_questionOf}=  Run Keyword And Return  Get Webelement  ${select_questionOf}
  Run Keyword If  ${exist_select_questionOf}  Select From List By Index  xpath=//select[@ng-model="chatData.questionOf"]  1

  Wait And Click   ${locator.send_question}

  Wait Until Page Contains  ${description}  20

Answer to question
   [Arguments]   ${username}  ${tender_id}  ${answer_data}  ${question_id}  @{ARGUMENTS}
   Log To Console  [+] Answer to question id: ${question_id}
   newtend.Пошук тендера по ідентифікатору  ${username}  ${tender_id}

   # go to tab chat
   Go To Questions Of Tender

   # wait to show chat item
   Wait Until Keyword Succeeds  8 minute  20 seconds  Wait For Question  ${question_id}
   Mouse Over  xpath=//div[contains(., '${question_id}')]  # should show answer btn
   # ckick to button answer to question
   Click Element   ${locator.ask_button_answer_to_question}

   # get data
   ${answer_text}=  Get From Dictionary  ${answer_data.data}  answer

   # input answer text
   Wait And Type  ${locator.ask__field_answer}  ${answer_text}

   # send answer
   Wait And Click  ${locator.ask__send_answer}

Wait For Question
  [Arguments]  ${question_id}
  Log To Console  [+]_ Wait for quesion id: ${question_id}
  Reload Page
  Wait Until Page Contains Element  xpath=//div[contains(., '${question_id}')]

Wait For Question Title
  [Arguments]  ${question_id}=
  Log To Console  [+]_ Wait for quesion id: ${question_id}
  Reload Page
  Wait Until Page Contains Element  xpath=//div[contains(., '${question_id}')]

Get Info From Question
  [Arguments]   @{ARGS}
  Print Args  ${ARGS}

  ${usesname}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}
  ${field_id}=  Set Variable  ${ARGS[2]}
  ${field_name}=  Set Variable  ${ARGS[3]}

  Find Tender By Id  ${tender_id}
  Go To Questions Of Tender
  Run Keyword And Return  Отримати інформацію запитання із поля ${field_name}  ${field_id}
  
Отримати інформацію запитання із поля questions[0].title
  [Arguments]  ${argument}
  Log To Console  [+] Get question[0]title
  Wait Until Keyword Succeeds  8 minute  20 s   Wait For Question Title  ${argument}
  ${result}=  Get Text  xpath=//span[contains(text(), '${argument}')]
  [return]  ${result}

Отримати інформацію запитання із поля title
  [Arguments]  ${argument}
  Log To Console  [+] Get question title
  ${question_0_title}=  Set Variable  xpath=//div[@class="row question-container"]/..//span[@class="user ng-binding"]
  Wait Until Keyword Succeeds  8 minute  20 s   Wait For Question Title  ${argument}
  ${result}=  Get Text  xpath=//span[contains(text(), '${argument}')]
  [return]  ${result}

Отримати інформацію запитання із поля description
  [Arguments]   ${argument}
  ${descriptions}=  Get Webelements     xpath=//span[@class="question-description ng-binding"]
  ${description}=   Get Text    ${descriptions[-1]}
  [return]  ${description}

Отримати інформацію запитання із поля questions[0].date
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
  ${day}=    Get Substring   ${resp}   0   2
  ${month}=  Get Substring   ${resp}   3   6
  ${rest}=   Get Substring   ${resp}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [return]  ${return_value}
