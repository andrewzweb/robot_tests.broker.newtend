** Settings ***
Resource  ../newtend.robot

*** Keywords ***

Canceled Lot
  [Arguments]  @{ARGS}
  [Documentation]  Input Data Example
  # UA-2021-11-09-000268-c
  # l-7812a396
  # c-443f6d22: Душарка победрина кормитися буніти штанці узголов'я сиротюк.
  # noDemand
  # /tmp/d-6e089097quodiQ7vgw.doc
  # Пороспорюватися бісовщина ракляцький утинок соненько воратися ревучий.

  ${tender_id}=  Set Variable  @{ARGS[0]}
  ${lot_id}=  Set Variable  @{ARGS[1]}
  ${complaint_id}=  Set Variable  @{ARGS[2]}
  ${reason_decline}=  Set Variable  @{ARGS[3]}
  ${complaint_doc}=  Set Variable  @{ARGS[4]}
  ${complaint_description}=  Set Variable  @{ARGS[5]}

Make draft complaint
  [Arguments]  @{ARGS}
  [Documentation]  Input Data Example
  ... UA-2021-10-28-000287-c
  ... -----------------------
  ... author:
  ...   address:
  ...     countryName: Україна
  ...     locality: Переяслав-Хмельницький
  ...     postalCode: '01111'
  ...     region: Київська область
  ...     streetAddress: Тестова вулиця, 21-29
  ...   contactPoint:
  ...     email: test_e_mail@ukr.net
  ...     faxNumber: '9998877'
  ...     name: Перший Тестовий Учасник
  ...     telephone: '+380506665544'
  ...     url: http://www.page.gov.ua/
  ... identifier:
  ...   id: '21725150'
  ...   legalName: Тестова районна в місті Києві державна адміністрація
  ...   scheme: UA-EDR
  ...   name: Тестова районна в місті Києві державна адміністрація
  ... description: Самопрядка роґлик сужена підставляти знахарювати заглитнутися паливо
  ...   матюнка займати злагідно обрубка.
  ... title: 'q-5d3e106b: Пообскрібати очевидьки клямати кормитися.'
  ... type: complaint
  ... -----------------------
  ... 0

  ${tender_id}=  Set Variable  @{ARGS[0]}
  ${complaint_data}=  Set Variable  @{ARGS[1]}
  ${item_index}=  Set Variable  @{ARGS[2]}


Get Info From Complaints
  [Arguments]  @{ARGS}
  # UA-2021-10-29-000102-d	
  # UA-2021-10-29-000102-d.c1	
  # status	
  # 0	
  # cancellations
