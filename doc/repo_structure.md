# Структура данного проекта

.
├── doc                                 # документация
│   └── main.md                         #
├── helper                              #
│   ├── locators.robot                  #
│   ├── newtend_service.py              #
│   └── newtend_service.pyc             #
├── LICENSE.txt                         #
├── newtend.robot                       # main (entry point)
├── plan                                #
│   ├── plan_helper.robot               #
│   ├── plan_locators.robot             #
│   └── plan.robot                      #
├── README.rst                          #
├── robot_tests.broker.newtend.egg-info #
│   ├── dependency_links.txt            #
│   ├── PKG-INFO                        #
│   ├── SOURCES.txt                     #
│   └── top_level.txt                   #
├── setup.py                            #
├── tender                              #
│   ├── tender_helper.robot             #
│   ├── tender_locators.robot           #
│   └── tender.robot                    #
├── tender.robot                        #
└── user                                #
    ├── user_helper.robot               #
    ├── user_locators.robot             #
    └── user.robot                      #


Основная идея в том чтобы разделить логику по директориям.
В каждой директории есть файл {DIR_NAME}.robot с одноименным названием в котором и создается данная сущность.
И так же есть файл {DIR_NAME}_actions.robot где хранятся все действия по поводу данной сущности.
Есть файл {DIR_NAME}_locators.robot где хранятся все локаторы относящиеся к поводу данной сущности.
Файл {DIR_NAME}_helper.robot там какие-то снипеты кода которые минимизируют повторение кода.


### Структура всего проекта

Этот репозиторий это часть другого проекта.
Он должен предоставлять KeyWords для других тестов.
По сути все тесты оборачиваются другими тестами.

├── bin                       # это папка с внутреними командами
├── bootstrap.py              # для установки
├── buildout.cfg              # для установки
├── develop-eggs              # для установки
├── eggs                      # для установки
├── ez_setup.py               # для установки
├── LICENSE.txt               # лицензия
├── op_robot_tests            # основкая папка с тест кейсами
├── op_robot_tests.egg-info   # внутрений файл
├── parts                     # автоматически создался при развертывании
├── README.rst                # дока
├── robot_tests_arguments     # наборы аргументов с которыми запускаются тесты
├── setup.cfg                 # для установки
├── setup.py                  # для установки
├── src                       # исходники с которыми нужно работать
└── test_output               # логи выполнения тестов

По сути нужно менять код только в директории src/{NAME_BROKER}.
