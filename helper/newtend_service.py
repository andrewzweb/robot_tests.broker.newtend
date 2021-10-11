# -*- coding: utf-8 -*-
from datetime import datetime, timedelta
from iso8601 import parse_date
#from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange
from helper_datetime import *
import json


def create_custom_guranteee(tender_data):
    #    guarantee:
    #      amount: 59846969.56
    #      currency: UAH
    lot_amount = tender_data['data']['lots'][0]['value']['amount']
    lot_currency = tender_data['data']['lots'][0]['value']['currency']
    guarantee = {'amount': lot_amount, 'currency': lot_currency}
    tender_data['data']['guarantee'] = guarantee
    return tender_data

def change_procuringEntity_identifier_id(tender_data):
    tender_data['data']['procuringEntity']['identifier']['id'] = u"00037256"
    return tender_data

def overwrite_procuringEntity_data(tender_data):
    tender_data['data']['procuringEntity']['name'] = u"Київський Тестовий Ліцей"
    tender_data['data']['procuringEntity']['identifier']['id'] = u"00037256"
    tender_data['data']['procuringEntity']['identifier']['legalName'] = u"Київський Тестовий Ліцей"
    # adress
    tender_data['data']['procuringEntity']['address']['postalCode'] = u"01453"
    tender_data['data']['procuringEntity']['address']['region'] = u"Київська область"
    tender_data['data']['procuringEntity']['address']['locality'] = u"Киев"
    tender_data['data']['procuringEntity']['address']['streetAddress'] = u"Перемоги 1"
    # contact point
    tender_data['data']['procuringEntity']['contactPoint']['email'] = u"e_mail_test@bigmir.net"
    tender_data['data']['procuringEntity']['contactPoint']['faxNumber'] = u"088-111-22-33"
    tender_data['data']['procuringEntity']['contactPoint']['name'] = u"Київський Тестовий Ліцей"
    tender_data['data']['procuringEntity']['contactPoint']['telephone'] = u"+3808801234567"
    tender_data['data']['procuringEntity']['contactPoint']['url'] = u"http://webpage.org.ua/"
    return tender_data

def overwrite_features_values(tender_data):
    try:
        tender_data['data']['features'][0]['enum'][0]['value'] = 1
        tender_data['data']['features'][0]['enum'][1]['value'] = 2
        tender_data['data']['features'][0]['enum'][2]['value'] = 3
    except:
        pass
    return tender_data

def is_one_string_include_other_string(target_string, pattern_string):
    result = None
    print(target_string, pattern_string)
    if str(pattern_string) in str(target_string):
        print(True, target_string, pattern_string)
        result = True
    elif str(pattern_string) not in str(target_string):
        print(False, target_string, pattern_string)
        result = False
    return result


def update_data_for_newtend(tender_data):
    return tender_data

def convert_str_to_float(str_number):
    return float(str_number)

def convert_budget(budget):
    budget_convertion = format(budget, '.2f')
    return budget_convertion

def convert_quantity(quantity):
    quantity_convertion = format(quantity, '.3f')
    return quantity_convertion

def convert_to_float(budget):
    converted_text = float(budget)
    return converted_text

def string_convert_to_float(budget):
    converted_text = float(budget)
    return converted_text


# Converting data from tendering place into CDB common values
def convert_to_newtend_normal(string):
    return {
        # type tender
        u'ЗАПЛАНОВАНИЙ': 'scheduled',
        u'(Предложение принято)': u'active',
        u'Active purchase': u'pending',
        u'ACTIVE PURCHASE': u'pending',
        u'Активна закупівля': u'pending',
        u'Активная закупка': u'pending',
        u'COMPLETED': u'active',
        u'ЗАВЕРШЕН': u'active',
        u'ЗАВЕРШЕНО': u'active',

        # value
        u"грн.": u"UAH",
        u"VAT incl.": True,
        u" VAT incl": True,
        u"c НДС": True,

        # value valueAddedTaxIncluded
        u"без ПДВ": False,
        u"з ПДВ": True,

        # classification
        u"DC 021:2015 classifier": u"ДК021",
        u"Классификатор ДК 021:2015": u"ДК021",
        u"Класифікатор ДК 021:2015": u"ДК021",
        u"ДКПП Classifier": u"ДКПП",
        u"Классификатор ДКПП": u"ДКПП",
        u"Класифікатор ДКПП": u"ДКПП",

        # item name
        u"pack": u"упаковка",
        u"set": u"набір",
        u"accounting unit": u"Одиниця",
        u"block": u"блок",
        u"bobbin": u"Бобіна",
        u"box": u"ящик",
        u"kilogram": u"кілограми",
        u"килограммы": u"кілограми",
        u"lot [unit of procurement]": u"лот",
        u"lot[unit of procurement]": u"лот",
        u"piece": u"штуки",

        # Milestone Codes
        u"Аванс": u"prepayment",
        u"Аванс": u"prepayment",
        u"Послеоплата": u"postpayment",
        u"Пiсляоплата": u"postpayment",

        # Milestone Titles
        u"Виконання робіт": u"executionOfWorks",
        u"Выполнение работ": u"executionOfWorks",
        u"Поставка товару": u"deliveryOfGoods",
        u"Поставка товара": u"deliveryOfGoods",
        u"Надання послуг": u"submittingServices",
        u"Предоставление услуг": u"submittingServices",
        u"Підписання договору": u"signingTheContract",
        u"Подписание договора": u"signingTheContract",
        u"Дата подання заявки": u"submissionDateOfApplications",
        u"Дата подачи заявки": u"submissionDateOfApplications",
        u"Дата виставлення рахунку": u"dateOfInvoicing",
        u"Дата выставления счета": u"dateOfInvoicing",
        u"Дата закінчення звітного періоду": u"endDateOfTheReportingPeriod",
        u"Дата окончания отчетного периода": u"endDateOfTheReportingPeriod",
        u"Інша подія": u"anotherEvent",
        u"Другое событие": u"anotherEvent",

        # milestone duration day type
        u"рабочих": u"working",
        u"робочих": u"working",
        u"банковских": u"banking",
        u"банківських": u"banking",
        u"календарных": u"calendar",
        u"календарних": u"calendar"

    }.get(string, string)


def key_by_value(val):
    for key, value in dict_units.items():
        if val == value:
            return key
    return "No such value"

def convert_to_human_like_data(raw_key):
    for key, value in dict_units.items():
        if key == raw_key:
            return value
    return "No such key: %s" % raw_key

dict_units = {
    # --- tender status ---
    u'ПРОПОЗИЦІЇ': 'active.qualification',
    u'КВАЛІФІКАЦІЯ': 'active.qualification',
    
    # --- bid status ---
    u'Отклонен': u'unsuccessful',
    u'Ожидает решение': u'pending',
    u'Предложение принято': u'active',

    # --- tender type ---
    u'Спрощені / Допорогові закупівлі': u'belowThreshold',
    u'(Предложение принято)': u'active',
    u'Діючий': u'active',
    u'ПРОПОЗИЦІЇ': u'active',
    u'Active purchase': u'pending',
    u'ACTIVE PURCHASE': u'pending',
    u'Активна закупівля': u'pending',
    u'Активная закупка': u'pending',
    u'COMPLETED': u'active',
    u'ЗАВЕРШЕН': u'active',
    u'ЗАВЕРШЕНО': u'active',

    # --- classifier ---
    u"DC 021:2015 classifier": u"ДК021",
    u"Классификатор ДК 021:2015": u"ДК021",
    u"Класифікатор ДК 021:2015": u"ДК021",
    u"ДКПП Classifier": u"ДКПП",
    u"Классификатор ДКПП": u"ДКПП",
    u"Класифікатор ДКПП": u"ДКПП",

    # --- unit name ---
    u"pack": u"упаковка",
    u"set": u"набір",
    u"accounting unit": u"Одиниця",
    u"block": u"блок",
    u"bobbin": u"Бобіна",
    u"box": u"ящик",
    u"kilogram": u"кілограми",
    u"килограммы": u"кілограми",
    u"lot [unit of procurement]": u"лот",
    u"lot[unit of procurement]": u"лот",
    u"piece": u"штуки",

    # --- value amount ---
    u"грн.": u"UAH",

    # --- value valueAddedTaxIncluded ---
    # uk
    u"з ПДВ": True,
    u"без ПДВ": False,
    # ru
    u"c НДС": True,
    u"без НДС": False,
    # en
    u" VAT incl": True,

    # milestone duration day type
    u"рабочих": u"working",
    u"робочих": u"working",
    u"банковских": u"banking",
    u"банківських": u"banking",
    u"календарных": u"calendar",
    u"календарних": u"calendar",

    # Milestone Codes
    u"Аванс": u"prepayment",
    u"Аванс": u"prepayment",
    u"prepayment": u"Аванс",
    u"Послеоплата": u"postpayment",
    u"Пiсляоплата": u"postpayment",

    # Milestone Titles
    u"Виконання робіт": u"executionOfWorks",
    u"Выполнение работ": u"executionOfWorks",
    u"Поставка товару": u"deliveryOfGoods",
    u"Поставка товара": u"deliveryOfGoods",
    u"Надання послуг": u"submittingServices",
    u"Предоставление услуг": u"submittingServices",
    u"Підписання договору": u"signingTheContract",
    u"Подписание договора": u"signingTheContract",
    u"Дата подання заявки": u"submissionDateOfApplications",
    u"Дата подачи заявки": u"submissionDateOfApplications",
    u"Дата виставлення рахунку": u"dateOfInvoicing",
    u"Дата выставления счета": u"dateOfInvoicing",
    u"Дата закінчення звітного періоду": u"endDateOfTheReportingPeriod",
    u"Дата окончания отчетного периода": u"endDateOfTheReportingPeriod",
    u"Інша подія": u"anotherEvent",
    u"Другое событие": u"anotherEvent",

    # milestone duration day type
    u"рабочих": u"working",
    u"робочих": u"working",
    u"банковских": u"banking",
    u"банківських": u"banking",
    u"календарных": u"calendar",
    u"календарних": u"calendar"
}

# u"cubic metre": u"
    # u"gigacalorie": u"
    # u"gram": u"
    # u"hectare": u"
    # u"hour": u"
    # u"job": u"
    # u"kilocalorie(international table)": u"
    # u"ream": u"
    # u"roll": u"
    # u"running or operating hour": u"
    # u"service": u"
    # u"unit": u"
    # u"square metre": u"
    # u"thousand cubic metre": u"
    # u"thousand piece": u"
    # u"tonne(metric ton)": u"
    # u"trip": u"
    # u"var": u"
    # u"vial": u"
    # u"working day": u"
    # u"megawatt hour per hour": u"
    # u"metre": u"
    # u"month": u"
    # u"number of packs": u"
    # u"pair": u"
    # u"person": u"
    # u"kilometre": u"
    # u"kilovar": u"
    # u"kilowatt": u"
    # u"kilowatt hour": u"
    # u"kit": u"
    # u"linear metre": u"
    # u"litre": u"

def check_its_plan(str_tender_or_plan):
    if 'UA-P-' in str_tender_or_plan:
        return True
    else:
        return False

def create_empty_list():
    return []

def convert_string_in_json(some_string):
    result = json.loads(some_string)
    return result
