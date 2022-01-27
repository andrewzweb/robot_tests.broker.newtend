*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Find Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Find Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${tender_id}=  Set Variable  ${ARGS[1]}

  #${tender_id}=  Get Substring  ${tender_id}  0  22
  #Find Tender By Id  ${tender_id}

  Go To Agreements
  ${url}=  Get Location
  ${agreement_id}=  Get Agreement From Url  ${url}

  ${path_to_agreement}=  Set Variable  ${HOST}/opc/provider/agreement/${agreement_id}
  Go To  ${path_to_agreement}

  Save Agreement In Global  ${username}  ${agreement_id}

  Log To Console  [+] ===== Find Agreement =====


Save Agreement In Global
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] __Save Agreement In Global
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}

  ${agreement_data}=  newtend_get_agreement  ${agreement_id}

  ${valid_agreement_data}=  op_robot_tests.tests_files.service_keywords.Munchify  ${agreement_data}
  Set To Dictionary  ${USERS.users['${username}']}   agreement_data=${valid_agreement_data}
  
  Log  ${USERS.users['${username}'].agreement_data}
  Log  ${USERS.users['${username}'].agreement_data.data}
  Log To Console  [+] __Save Agreement In Global: ${agreement_id}

Get Info From Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Get Info From Agreement =====
  Print Args  @{ARGS}
  # changes[0].rationaleType
  # changes[0].rationale

Get Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Get Agreement =====
  Print Args  @{ARGS}

  # args1 - username
  # args1 - tender_id


Download Doc In Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Download Doc In Agreement =====
  Print Args  @{ARGS}

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_doc}=  Set Variable  ${ARGS[1]}
  ${agreement_id}=  Set Variable  ${ARGS[2]}

  Wait And Click  xpath=//button[@ng-click="vm.uploadDocuments(true)"]
  Sleep  2
  Select From List by Value  xpath=//select[@ng-model="document.documentType"]  contractAnnexe

  Wait And Click  xpath=//div[@ng-model="file"]

  Choose File  xpath=//input[@type="file"]  ${agreement_doc}

  Sleep  5

  Execute Javascript
  ...  var element=document.querySelector("button[ng-click='upload()']");
  ...  element.removeAttribute("disabled");
  
  Wait And Click  xpath=//button[@ng-click="upload()"]

  Log To Console  [+] __ Download Doc In Agreement

Change Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Change Agreement =====
  Print Args  @{ARGS}

  # args1 - user
  # args2 - tender_id
  #
  # args3 -
  # ====
  # Можливість внести зміну до угоди taxRate
  #
  # data:
  #  rationale: Накрашувати спонаджувати четверговий пошкарубитися баришок хобза муничитися
  #      поратування ушнипитися оленя підсмалити головистий порозгризати змерлий.
  #  rationaleType: taxRate
  #  rationale_en: Cum aspernatur velit quod rerum dolore odio illo.
  #  rationale_ru: Вэртырэм либриз эа мыдиокрым пэртинакёа луптатум вэрыар.
  #
  # =====
  # Можливість внести зміну до угоди thirdParty
  #
  # data:
  #  rationale: Обрубка осмолювати гупалка оповідь побабіти дітки наємець закут.
  #  rationaleType: thirdParty
  #  rationale_en: Officiis tempore adipisci consectetur sit reiciendis provident asperiores
  #      id assumenda inventore a.
  #  rationale_ru: Жкаывола фалля рэгяонэ шапэрэт витюпырата ючю чонэт янтэрэсщэт мыа
  #      ылоквюэнтиам квюандо.

  ${username}=  Set Variable  ${ARGS[0]}
  ${agreement_id}=  Set Variable  ${ARGS[1]}
  ${agreement_data}=  Set Variable  ${ARGS[2]}

  ${agreement_rationale}=  Get From Dictionary  ${agreement_data.data}  rationale
  ${agreement_type}=  Get From Dictionary  ${agreement_data.data}  rationaleType
  ${agreement_rationale_ru}=  Get From Dictionary  ${agreement_data.data}  rationale_en
  ${agreement_rationale_en}=  Get From Dictionary  ${agreement_data.data}  rationale_ru

  Hide Wallet

  Sleep  3

  Wait And Click  xpath=//button[@ng-click="vm.openModal('price')"]
  
  Wait And Type  xpath=//textarea[@ng-model="rationale_ru"]  ${agreement_rationale}
  Wait And Type  xpath=//textarea[@ng-model="rationale_en"]  ${agreement_rationale_en}

  Select From List by Value  xpath=//select[@id="operationType"]  ${agreement_type}

  Wait And Click  xpath=//button[@ng-click="setChanges()"]

  Sleep  10

Apply Chenges Agreement
  [Arguments]  @{ARGS}
  Log To Console  \n [ ] ===== Apply Chenges Agreement =====
  Print Args  @{ARGS}
  
  # ====
  # args3 - active
  # 
  # ===
  # args3 - cancelled
  #   
  # =====

Get Agreement From Url
  [Arguments]  ${url}
  ${clear_agreement_id}=  Get Substring  ${url}  -32
  Log To Console  [ ] Agreement: ${clear_agreement_id}
  [Return]  ${clear_agreement_id}
