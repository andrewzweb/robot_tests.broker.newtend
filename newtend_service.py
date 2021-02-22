# -*- coding: utf-8 -*-
from datetime import datetime
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange


def newtend_date_picker_index(isodate):
    now = get_now()
    date_str = '01' + str(now.month) + str(now.year)
    first_day_of_month = datetime.strptime(date_str, "%d%m%Y")
    mod = first_day_of_month.isoweekday() - 2
    iso_dt = parse_date(isodate)
    # last_day_of_month = monthrange(now.year, now.month)[1]
    # LOGGER.log_message(Message("last_day_of_month: {}".format(last_day_of_month), "INFO"))
    if now.day > iso_dt.day:
        mod = monthrange(now.year, now.month)[1] + mod
    return mod + iso_dt.day


def update_data_for_newtend(tender_data):
    tender_data.data.procuringEntity['name'] = u"openprocurement"
    return tender_data


def convert_budget(budget):
    budget_convertion = format(budget, '.2f')
    return budget_convertion


def convert_quantity(quantity):
    quantity_convertion = format(quantity, '.3f')
    return quantity_convertion


# Converting data from tendering place into CDB common values
def convert_to_newtend_normal(string):
    return {
        u'ЗАПЛАНОВАНИЙ': 'scheduled',
        u'(Предложение принято)': u'active',
        u'Active purchase': u'pending',
        u'ACTIVE PURCHASE': u'pending',
        u'Активна закупівля': u'pending',
        u'Активная закупка': u'pending',
        u'COMPLETED': u'active',
        u'ЗАВЕРШЕН': u'active',
        u'ЗАВЕРШЕНО': u'active',
        u"грн.": u"UAH",
        u"VAT incl.": True,
        u" VAT incl": True,
        u"c НДС": True,
        u"DC 021:2015 classifier": u"ДК021",
        u"Классификатор ДК 021:2015": u"ДК021",
        u"Класифікатор ДК 021:2015": u"ДК021",
        u"ДКПП Classifier": u"ДКПП",
        u"Классификатор ДКПП": u"ДКПП",
        u"Класифікатор ДКПП": u"ДКПП",
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
        u"piece": u"штуки"
    }.get(string, string)


def key_by_value(val):
    for key, value in dict_units.items():
        if val == value:
            return key
    return "No such key"

dict_units = {
    u'(Предложение принято)': u'active',
    u'Active purchase': u'pending',
    u'ACTIVE PURCHASE': u'pending',
    u'Активна закупівля': u'pending',
    u'Активная закупка': u'pending',
    u'COMPLETED': u'active',
    u'ЗАВЕРШЕН': u'active',
    u'ЗАВЕРШЕНО': u'active',
    u"грн.": u"UAH",
    u"VAT incl.": True,
    u" VAT incl": True,
    u"c НДС": True,
    u"DC 021:2015 classifier": u"ДК021",
    u"Классификатор ДК 021:2015": u"ДК021",
    u"Класифікатор ДК 021:2015": u"ДК021",
    u"ДКПП Classifier": u"ДКПП",
    u"Классификатор ДКПП": u"ДКПП",
    u"Класифікатор ДКПП": u"ДКПП",
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
    u"piece": u"штуки"
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
