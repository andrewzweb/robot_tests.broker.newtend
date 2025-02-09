# -*- coding: utf-8 -*-
import subprocess
from datetime import datetime, timedelta
from iso8601 import parse_date
#from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange
from helper_datetime import *
import json
import requests

run_local = True

def create_custom_guranteee(tender_data):
    #    guarantee:
    #      amount: 59846969.56
    #      currency: UAH
    lot_amount = tender_data['data']['lots'][0]['value']['amount']
    lot_currency = tender_data['data']['lots'][0]['value']['currency']
    guarantee = {'amount': lot_amount, 'currency': lot_currency}
    tender_data['data']['guarantee'] = guarantee
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
        tender_data['data']['procuringEntity']['contactPoint']['url'] = u"http://www.testowner.ua"
    except: pass
    return tender_data

def overwrite_procuringEntity_data_for_owner(tender_data):
    try:
        tender_data['data']['procuringEntity']['name'] = u"Newtend Test Owner"
        tender_data['data']['procuringEntity']['identifier']['id'] = u"1234567892"
        tender_data['data']['procuringEntity']['identifier']['legalName'] = u"Newtend Test Owner"
    except: pass
    # adress
    try:
        tender_data['data']['procuringEntity']['address']['postalCode'] = u"54100"
        tender_data['data']['procuringEntity']['address']['region'] = u"Київська область"
        tender_data['data']['procuringEntity']['address']['locality'] = u"Киев"
        tender_data['data']['procuringEntity']['address']['streetAddress'] = u"переулок Ярославский 1/3"
    except: pass
    # contact point
    try:
        tender_data['data']['procuringEntity']['contactPoint']['email'] = u"e_mail_test@bigmir.net"
        tender_data['data']['procuringEntity']['contactPoint']['faxNumber'] = u"088-111-22-33"
        tender_data['data']['procuringEntity']['contactPoint']['name'] = u"Newtend Test Owner"
        tender_data['data']['procuringEntity']['contactPoint']['telephone'] = u"+380991234560"
        tender_data['data']['procuringEntity']['contactPoint']['url'] = u"http://test_owner.ua/"
    except: pass
    return tender_data


def overwrite_procuringEntity_for_plan(tender_data):
    try:
        tender_data['data']['procuringEntity']['name'] = u"Newtend Test Owner"
        tender_data['data']['procuringEntity']['identifier']['id'] = u"1234567892"
        tender_data['data']['procuringEntity']['identifier']['legalName'] = u"Newtend Test Owner"
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
        tender_data['data']['procuringEntity']['contactPoint']['faxNumber'] = u"088-111-22-33"
        tender_data['data']['procuringEntity']['contactPoint']['name'] = u"Newtend Test Owner"
        tender_data['data']['procuringEntity']['contactPoint']['telephone'] = u"+380991234560"
        tender_data['data']['procuringEntity']['contactPoint']['url'] = u"http://webpage.org.ua/"
    except: pass
    return tender_data

def overwrite_plan_data(plan_data):
    # 2021-12-28T00:00:00+02:00
    # 2021-12-27T23:00:00+03:00
    old_date = plan_data['data']['procuringEntity']['items'][0]['deliveryDate']['endDate']
    new_date = change_endDate_for_plan(old_date)
    plan_data['data']['procuringEntity']['items'][0]['deliveryDate']['endDate'] = new_date
    return plan_data

def change_endDate_for_plan(date):
    data = str(date)
    new_date = data[:20] + "02:00"
    return new_date

def convert_enum_str_to_int(enum):
    enum = float(enum) * 100
    return int(enum)

def is_one_string_include_other_string(target_string, pattern_string):
    result = False
    target_string = str(target_string.encode('ascii','ignore'))
    pattern_string = str(pattern_string.encode('ascii','ignore'))
    if pattern_string in target_string:
        result = True
    elif pattern_string not in target_string:
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

def multiply_to_hundren(numb):
    numb= float(str(numb))
    result = numb * 100
    return str(result)

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
    u'НЕ ВІДБУВСЯ': u'draft.unsuccessful',
    u"АУКЦІОН": u'active.auction',
    u'КВАЛІФІКАЦІЯ': u'active.qualification',
    u'ПРЕКВАЛІФІКАЦІЯ': u'active.pre-qualification',
    u'УТОЧНЕННЯ': u'active.enquiries',
    u'ПРОПОЗИЦІЇ': u'active.tendering',
    u'ПРЕКВАЛІФІКАЦІЯ (ПЕРІОД ОСКАРЖЕННЯ)': u'active.pre-qualification.stand-still',
    u'ПРОВЕДЕННЯ ПЕРЕГОВОРІВ': u'complete',
    u'ОЧІКУВАННЯ ДРУГОГО ЕТАПУ': u'complete',
    u'ЧЕРНЕТКА. ДРУГИЙ ЕТАП':  u'draft.stage2',
    u'ПЕРІОД ЗАПРОШЕННЯ': u'active.enquiries',

    # tender status ru
    u'НЕСОСТОЯЛСЯ':  u'draft.unsuccessful',
    u"АУКЦИОН": u'active.auction',
    u'КВАЛИФИКАЦИЯ': u'active.qualification',
    u'ПРЕКВАЛИФИКАЦИЯ':  u'active.pre-qualification',
    u'УТОЧНЕНИЯ': u'active.enquiries',
    u'ПРЕДЛОЖЕНИЯ': u'active.tendering',
    u'ПРЕКВАЛИФИКАЦИЯ (ПЕРИОД ОБЖАЛОВАНИЯ)': u'active.pre-qualification.stand-still',
    u'ПРОВЕДЕНИЯ ПЕРЕГОВОРОВ': u'complete',
    u'ОЖИДАНИЕ ВТОРОГО ЭТАПА': u'complete',
    u'ЧЕРНОВИК. ВТОРОЙ ЭТАП':  u'draft.stage2',

    # complaint status
    u'Очікує розгляду /':         u'pending',
    u'Залишено без розгляду /':   u'invalid',
    u'Прийнята до розгляду /':    u'accepted',
    u'Скасовано /':               u"mistaken",
    u'Розгляд припинено /':       u'stopped',
    u'Відмовлено в задоволені /': u'declined',
    u'Чернетка /':                u'draft',
    u'Задоволено /':              u'satisfied',
    u'Порушення усунуте /':       u'resolved',

    # ru
    u'Черновик. Второй этап': u'draft.stage2',
    u'Объявление второго этапа' : u'active.stage2.waiting',
    u'Ожидание второго этапа' : u'active.stage2.pending',
    u'Завершен' : u'complete',
    u'Несостоявшийся': u'unsuccessful',
    u'Рассмотрен' : u'active.awarded',
    u'Кваліфікація переможців (період оскарження)' : u'active.qualification.stand-still',
    u"Проведение переговоров" : u"active.pre-qualification.stand-still",
    u'Прекваліфікація (період оскарження)': u'active.pre-qualification.stand-still',
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
    u'ЗАВЕРШЕН': u'complete',
    u'ЗАВЕРШЕНО': u'complete',

    # plan status
    u"ЧЕРНЕТКА": u"draft",
    u"Чернетка": u"draft",
    u"ЗАПЛАНОВАНИЙ": u"scheduled",
    u"Запланований": u"scheduled",
    u"СКАСОВАНИЙ": u"cancelled",
    u"Скасований": u"cancelled",
    u"ОГОЛОШЕНИЙ ТЕНДЕР": u"complete",
    u"Оголошений тендер": u"complete",

    # --- quallification ---
    u"Пропозицію прийнято": u"active",
    u"Очікується кваліфікація": u"pending",
    u"Пропозицію відхилено": u"unsuccessful",

    # --- quallification ru ---
    u"Предложение пряйнято": u"active",
    u"Ожидается квалификация": u"pending",
    u"Предложение отменено": u"unsuccessful",

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

def api_get_bid_id_hash(tender_internal_id, numb):
    result = False
    tender = newtend_get_tender(tender_internal_id)
    numb = int(numb)
    result = tender['data']['qualifications'][numb]['bidID']
    return result

def api_get_bid_id_from_qualification(tender_internal_id, numb):
    result = False
    tender = newtend_get_tender(tender_internal_id)
    numb = int(numb)
    result = tender['data']['qualifications'][numb]['bidID']
    return result

def api_get_bid_id_from_award(tender_internal_id, numb):
    result = False
    tender = newtend_get_tender(tender_internal_id)
    numb = int(numb)
    result = tender['data']['awards'][numb]['bid_id']
    return result

def api_get_tenderPeriod_end_date(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['tenderPeriod']['endDate']
    return result

def api_sync_tender(internal_id):
    if run_local:
        response = requests.get('http://localhost:8000/api/v2/sync_tender/%s/' % (internal_id))
    else:
        response = requests.get('https://autotest.newtend.com/api/v2/sync_tender/%s/' % (internal_id))
    return response.status_code

def api_sync_contract(internal_id):
    response = requests.get('https:/autotest.newtend.com/api/v2/sync_contract/%s/' % (internal_id))
    return response.status_code

def api_get_complaint(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['complaints']
    return result

def api_get_cancellation(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['cancellations']
    return result

def convert_bid_amount(raw_amount):
    result = str(raw_amount[0]).replace(' ', '').replace(',', '.')
    return float(result)

def return_number_element_check_hash(data, search_hash):
    result = None
    for x in range(len(data['data'])):
        id_hash = data['data'][x]['requirement']['id']
        print(id_hash)
        if str(id_hash) == str(search_hash):
            result = x
    return result

def api_get_award_id(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['cancellations']
    return result

def api_get_tender_amount(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['value']['amount']
    return str(round(float(result) * 0.9, 2))

def api_get_complaint_from_cancellation(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['cancellations'][0]['complaints'][0]
    return result

def api_get_complaint_from_qualification(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['qualifications'][0]['complaints'][0]
    return result

def api_get_complaint_from_award(tender_internal_id):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['awards'][0]['complaints'][0]
    return result

def api_get_first_award_id(tender_internal_id, award_index):
    tender = newtend_get_tender(tender_internal_id)
    number_award = int(str(award_index)) - 1
    result = tender['data']['awards'][number_award]['bid_id']
    return result

def plus_one(number):
    result = int(number) + 1
    return result

def get_amount_for_bid(tender_data, tender_internal_id):
    amount = False
    try:
        current = tender_data['data']['lotValues'][0]['value']['amount']
    except:
        pass

def update_repo():
    #subprocess.call('cd src/robot_tests.broker.newtend && pwd && last_commit=$(git log -n 1 --pretty=format:"[ %h ] %ar : %s") && echo $last_commit ', shell=True, stdout=None)
    #subprocess.call('pwd', shell=True, stdout=None)
    #subprocess.call('bin/develop update -f', shell=True)
    return 'Succses!!!'

def info_from_git():
    subprocess.call('cd src/robot_tests.broker.newtend && pwd && last_commit=$(git log -n 1 --pretty=format:"[ %h ] %ar : %s") && echo $last_commit ', shell=True, stdout=None)

def str_in_list(string_target, _list):
    result = False
    for i in _list:
        if str(i) == str(string_target):
            result = True
    return result

def black_list_tender_for_feature():
    return [u'esco', u'competitiveDialogueEU', u'competitiveDialogueUA']

def multiply_float_and_return_string(str_float):
    numb = float(str(str_float)) * 100
    return str(numb).replace(".",",")[:5]

def multiply_float_and_return_string_for_esco(str_float):
    numb = float(str(str_float)) * 100
    return str(numb)[:5]

def change_number_to_string(number):
    return str(number)

def get_plan_data_from_cbd(plan_hash_id):
    url = "https://lb-api-staging.prozorro.gov.ua/api/2.5/plans/" + plan_hash_id
    request = requests.get(url)
    plan = json.loads(request.text)
    plan_endDate =  plan['data']['items'][0]['deliveryDate']['endDate']
    return plan_endDate

def get_doc_from_cbd(url, output_dir):
    '''url -> filename'''
    filename = 'tmp.docx'
    request = requests.get(str(url), allow_redirects=True)
    open(output_dir + "/" + filename,'wb').write(request.content)
    return filename

def read_text_from_file(filename):
    '''filename -> text'''
    text = open(filename, 'r').read()
    text = text.decode("utf-8")
    return text

def api_get_bids_hash(tender_internal_id, number):
    tender = newtend_get_tender(tender_internal_id)
    result = tender['data']['bids'][int(number)]['id']
    return str(result)

def convert_budget_amount(amount):
    amount = str(amount)
    amount = amount.replace(' ', '')
    amount = amount.replace(',', '.')
    amount = float(amount)
    return amount

def api_get_agreements_from_tender(tender_internal_id):
    agreement_data = False
    tender_data = newtend_get_tender(tender_internal_id)

    url = "https://lb-api-staging.prozorro.gov.ua/api/0/tenders/" + tender_internal_id + '/agreements'
    request = requests.get(url)
    data = json.loads(request.text)
    return data

def api_get_contracts_from_agreeements(tender_internal_id):
    data = api_get_agreements_from_tender(tender_internal_id)
    print(data['data'][0])
    clean_data = data['data'][0]['contracts'][0]
    return clean_data

def newtend_get_agreement(agreement_internal_id):
    """
    input agreement_internal_id

    return python dict with agreement

    make request to api and get agreement data
    url like
    https://lb-api-staging.prozorro.gov.ua/api/0/agreements/bd861e500f344165bb3ac0b8301292f8
    """

    url = "https://lb-api-staging.prozorro.gov.ua/api/0/agreements/" + agreement_internal_id
    request = requests.get(url)
    tender = json.loads(request.text)
    return tender

