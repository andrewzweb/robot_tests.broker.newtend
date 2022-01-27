*** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Get Agreement
  [Arguments]  @{ARGS}
  Log To Console  [ ] ===== ${TEST_NAME} =====
  Print Args  @{ARGS}

  # args1 - username
  # args1 - tender_id
  
Download Doc In Agreement
  [Arguments]  @{ARGS}
  Log To Console  [ ] ===== ${TEST_NAME} =====
  Print Args  @{ARGS}

Change Agreement
  [Arguments]  @{ARGS}
  Log To Console  [ ] ===== ${TEST_NAME} =====
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

  
Apply Chenges Agreement
  [Arguments]  @{ARGS}
  Log To Console  [ ] ===== ${TEST_NAME} =====
  Print Args  @{ARGS}
  
  # ====
  # args3 - active
  # 
  # ===
  # args3 - cancelled
  #   
  # =====
