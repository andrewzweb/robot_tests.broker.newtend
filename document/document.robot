*** Variables ***
${locator.documents_link_tab}  xpath=//a[@ui-sref="tenderView.documents"]
${locator.documents_button_add}  xpath=//button[@ng-click="uploadDocument()"]
${locator.documents_form}  xpath=//form[@name="uploadDocumentsForm"]
${locator.document_for}  xpath=//select[@ng-model="document.documentOf"]
${locator.document_type}  xpath=//select[@ng-model="document.documentType"]
${locator.document_file_button}  xpath=//button[@ng-model="file"]
${locator.document_file}  xpath=//input[@type="file"]
${locator.documents_send_document}  xpath=//button[@ng-click="upload()"]

*** Keywords ***

Download Document
  [Arguments]  ${document_file}  ${document_for}  ${document_type}
  [Documentation]  Uni downloader doc
  ...  document_file
  ...    some file dox or pdf
  ...  document_for
  ...  - tender
  ...  - lot
  ...  - item
  ...  document_type
  ...  - отчет про заключенные договоры = notice
  ...  - документы закупки = biddingDocuments
  ...  - технические спецификации = technicalSpecifications
  ...  - критерии оценки = evaluationCriteria
  ...  - ответы на вопросы = clarifications
  ...  - критерии валидности = eligibilityCriteria
  ...  - фирмы в коротком списке = shortlistedFirms
  ...  - положение для управления рисками = riskProvisions
  ...  - квалификацилнные критерии = bidders
  ...  - конфликт интересов = conflictOfInterest
  ...  - отказ к допуску до закупки = debarments
  ...  - проект договора = contractProforma

  # go to document tab
  Go To Document Of Tender
  Wait And Click  ${locator.documents_button_add}
  Wait Until Element Is Visible  ${locator.documents_form}
  # for
  Select From List By Value  ${locator.document_for}  ${document_for}
  # choise type document
  Select From List By Value  ${locator.document_type}  ${document_type}
  # click to file input shows
  Wait And Click  ${locator.document_file_button}
  # choise type document
  Sleep  2
  Wait Until Page Contains Element  ${locator.document_file}
  Choose File  ${locator.document_file}  ${document_file}
  Wait And Click  ${locator.documents_send_document}
  Sleep  2

Отримати інформацію про documents[0].title
  Click Element     xpath=//a[@ui-sref="tenderView.documents"]
  Sleep     4
  ${document_title}=    Get Text    xpath=//h3[contains(., 'Procurement documentation')]/..//a[@class="ng-binding"]
  log to Console    doc title - '${document_title}'
  Sleep     2
  Click Element     xpath=//a[@ui-sref="tenderView.overview"]
  Sleep     4
  [Return]      ${document_title}
