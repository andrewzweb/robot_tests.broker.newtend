# -*- coding: utf-8 -*-
from datetime import datetime, timedelta
from iso8601 import parse_date
#from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange
from helper_datetime import *
import json
import requests

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
    tender_data['data']['procuringEntity']['identifier']['id'] = u"1234567892"
    return tender_data

def overwrite_procuringEntity_data(tender_data):
    try:
        tender_data['data']['procuringEntity']['name'] = u"newtend provider company"
        tender_data['data']['procuringEntity']['identifier']['id'] = u"12312313123"
        tender_data['data']['procuringEntity']['identifier']['legalName'] = u"newtend owner company"
    except: pass
    # adress
    try:
        tender_data['data']['procuringEntity']['address']['postalCode'] = u"01453"
        tender_data['data']['procuringEntity']['address']['region'] = u"Київська область"
        tender_data['data']['procuringEntity']['address']['locality'] = u"Киев"
        tender_data['data']['procuringEntity']['address']['streetAddress'] = u"Перемоги 1"
    except: pass
    # contact point
    try:
        tender_data['data']['procuringEntity']['contactPoint']['email'] = u"e_mail_test@bigmir.net"
        tender_data['data']['procuringEntity']['contactPoint']['faxNumber'] = u"088-111-22-33"
        tender_data['data']['procuringEntity']['contactPoint']['name'] = u"newtend owner company"
        tender_data['data']['procuringEntity']['contactPoint']['telephone'] = u"+380991234560"
        tender_data['data']['procuringEntity']['contactPoint']['url'] = u"http://webpage.org.ua/"
    except: pass
    return tender_data

def overwrite_features_values_in_new_feature(feature):
    feature['enum'][0]['value'] = 1
    feature['enum'][1]['value'] = 2
    feature['enum'][2]['value'] = 2
    return feature

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

def convert_for_robot(raw_key):
    for key, value in dict_units.items():
        if key == raw_key:
            return value
    return "No such key: |%s|" % raw_key

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
    u'КВАЛІФІКАЦІЯ': u'active.pre-qualification',
    u'ПРЕКВАЛІФІКАЦІЯ': u'active.qualification',
    u'УТОЧНЕННЯ': u'active.enquiries',
    u'ПРОПОЗИЦІЇ': u'active.tendering',
    u'Черновик. Второй этап': u'draft.stage2',
    u'Объявление второго этапа' : u'active.stage2.waiting',
    u'Ожидание второго этапа' : u'active.stage2.pending',
    u'Завершен' : u'complete',
    u'Несостоявшийся': u'unsuccessful',
    u'Рассмотрен' : u'active.awarded',
    u'Кваліфікація переможців (період оскарження)' : u'active.qualification.stand-still',
    u"Проведение переговоров" : u"active.pre-qualification.stand-still",
    u'Прекваліфікація (період оскарження)': 'active.pre-qualification.stand-still',
    u'Аукцион' : u'active.auction',
    u'Предложения' : u'active.tendering',
    u'Уточнение' : u'active.enquiries',
    u'Період запрошення': u'active.enquiries',
    u'Активная закупка': u'active',
    u'Неуспішна закупівля': u'draft.unsuccessful',
    u'Неактивоване запрошення': u'draft.pending',
    u'Чернетка': u'local_draft',

    # --- bid status ---
    u'Отклонен': u'unsuccessful',
    u'Ожидает решение': u'pending',
    u'Предложение принято': u'active',

    # --- tender type ---
    u'Спрощені / Допорогові закупівлі': u'belowThreshold',
    u'(Предложение принято)': u'active',
    u'Діючий': u'active',
    u'Active purchase': u'pending',
    u'ACTIVE PURCHASE': u'pending',
    u'Активна закупівля': u'pending',
    u'Активная закупка': u'pending',
    u'COMPLETED': u'active',
    u'ЗАВЕРШЕН': u'active',
    u'ЗАВЕРШЕНО': u'active',

    # plan status
    u"ЧЕРНЕТКА": u"draft",
    u"Чернетка": u"draft",
    u"ЗАПЛАНОВАНИЙ": u"scheduled",
    u"Запланований": u"scheduled",
    u"СКАСОВАНИЙ": u"cancelled",
    u"Скасований": u"cancelled",
    u"ОГОЛОШЕНИЙ ТЕНДЕР": u"complete",
    u"Оголошений тендер": u"complete",

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

dict_tender_status = {
    # CANCELLATION_STATUS:
    "DRAFT" : 'draft',                 # За замовчуванням. Скасування у стані формування.
    "PENDING" : 'pending',             # Запит оформлюється.
    "ACTIVE" : 'active',               # Скасування активоване.
    "UNSUCCESSFUL" : 'unsuccessful',   # Невдале скасування

    # status
    "LOCAL_DRAFT" : 'local_draft',
    "DRAFT" : 'draft',                 # черновик (для 2-х фазового комита)
    "DRAFT_PENDING" : 'draft.pending',
    "DRAFT_UNSUCCESSFUL" : 'draft.unsuccessful',
    "ENQUIRIES" : 'active.enquiries',  # уточнение (две даты - начало и конец)
    "TENDERING" : 'active.tendering',  # предложение - делают ставки  (две даты - начало и конец)
    "AUCTION" : 'active.auction',      # аукцион - если 2 и более поставщиков сделали ставку
    "QUALIFICATION" : 'active.qualification',  # квалификация - выбор победителя
    "AWARDED" : 'active.awarded',  # рассмотрен -  если выбран победитель
    "UNSUCCESSFUL" : 'unsuccessful',  # несостоявшийся  - никто не сделал ставку либо все ставки отменены
    "COMPLETE" : 'complete',  # завершен - нажали кнопку закончить торги
    "CANCELLED" : 'cancelled',  # отменен - нажали кнопку отменить
    "STAGE2_PENDING" : 'active.stage2.pending',
    "STAGE2_WAITING" : 'active.stage2.waiting',
    "DRAFT_STAGE2" : 'draft.stage2',

    "ACTIVE" : 'active',  # активный тендер для переговорной процедуры
    "PRE_QUALIFICATION" : 'active.pre-qualification',  # предварительная квалификация (openEU)
    "PRE_QUALIFICATION_STAND_STILL" : 'active.pre-qualification.stand-still',  # предварительная квалификация (openEU)
    "QUALIFICATION_STAND_STILL" : 'active.qualification.stand-still',  # квалификация (closeFrameworkAgreementEU)
}
    
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

def newtend_get_tender(tender_internal_id):
    """
    input tender_internal_id

    return python dict with tender

    make request to api and get tender data
    url like
    https://lb-api-staging.prozorro.gov.ua/api/0/tenders/bd861e500f344165bb3ac0b8301292f8
    """

    url = "https://lb-api-staging.prozorro.gov.ua/api/0/tenders/" + tender_internal_id
    request = requests.get(url)
    tender = json.loads(request.text)
    return tender

def fake_document_response(doc_file):
    print(doc_file)
    result = {"data": {"id": '123543523452345', "title": str(doc_file)}}
    return result
