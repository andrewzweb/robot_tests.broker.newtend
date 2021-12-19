# -*- coding: utf-8 -*-
from datetime import datetime, timedelta
from iso8601 import parse_date


def change_minute_in_date(date_time_str, minutes=0, plus=True):
    date_time_str = date_time_str[:10] + ' ' + date_time_str[11:26]
    date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S.%f')
    delta = timedelta(minutes=int(minutes),milliseconds=0)
    if plus:
        new_date_time_obj = date_time_obj + delta
    else:
        new_date_time_obj = date_time_obj - delta
    return new_date_time_obj.strftime('%Y-%m-%dT%H:%M:%S.%f+03:00')

def custom_date(tender_data, enquiry_start, enquiry_end, tender_start, tender_end, item_start, item_end):
    try:
        date_now = get_now_date()
        new_enquiryPeriod_startDate = change_datetime(date_now, int(enquiry_start), "plus")
        tender_data['data']['enquiryPeriod']['startDate'] = new_enquiryPeriod_startDate
        print("change enduiryPeriod_startDate", new_enquiryPeriod_startDate)
    except:
        print("[-] dont change enduiryPeriod_startDate", new_enquiryPeriod_startDate)

    try:
        date_now = get_now_date()
        new_enquiryPeriod_endDate = change_datetime(date_now, int(enquiry_end), "plus")
        tender_data['data']['enquiryPeriod']['endDate'] = new_enquiryPeriod_endDate
        print("change new_enquiryPeriod_endDate", new_enquiryPeriod_endDate)
    except:
        print("[-] dont change new_enquiryPeriod_endDate", new_enquiryPeriod_endDate)

    try:
        date_now = get_now_date()
        new_tenderPeriod_startDate = change_datetime(date_now, int(tender_start), "plus")
        tender_data['data']['tenderPeriod']['startDate'] = new_tenderPeriod_startDate
        print("change new_tenderPeriod_endDate", new_tenderPeriod_startDate)
    except:
        print("[-] change new_tenderPeriod_endDate", new_tenderPeriod_startDate)

    try:
        date_now = get_now_date()
        new_tenderPeriod_endDate = change_datetime(date_now, int(tender_end), "plus")
        tender_data['data']['tenderPeriod']['endDate'] = new_tenderPeriod_endDate
        print("change new_tenderPeriod_endDate", new_tenderPeriod_endDate)
    except:
        print("[-] dont change new_tenderPeriod_endDate", new_tenderPeriod_endDate)

    try:
        date_now = get_now_date()
        new_itemDelivery_startDate = change_datetime(date_now, int(item_start), "plus")
        tender_data['data']['items'][0]['deliveryDate']['startDate'] = new_itemDelivery_startDate
        print("change new_itemDelivery_startDate", new_itemDelivery_startDate)
    except:
        print("[-] dont change new_itemDelivery_startDate", new_itemDelivery_startDate)

    try:
        date_now = get_now_date()
        new_itemDelivery_endDate = change_datetime(date_now, int(item_end), "plus")
        tender_data['data']['items'][0]['deliveryDate']['endDate'] = new_itemDelivery_endDate
        print("change new_itemDelivery_endDate", new_itemDelivery_endDate)
    except:
        print("[-] dont change new_itemDelivery_endDate", new_itemDelivery_endDate)

    return tender_data

def change_minits_for_tests(tender_data, enquiry_start, enquiry_end, tender_start, tender_end, delirery_start, delirery_end):
    try:
        enduiryPeriod_startDate = get_now_date()
        new_enduiryPeriod_startDate = change_minute_in_date(enduiryPeriod_startDate, minutes=int(enquiry_start))
        tender_data['data']['enquiryPeriod']['startDate'] = new_enduiryPeriod_startDate
    except: pass

    try:
        enduiryPeriod_endDate = get_now_date()
        new_enduiryPeriod_endDate = change_minute_in_date(enduiryPeriod_endDate, minutes=int(enquiry_end))
        tender_data['data']['enquiryPeriod']['endDate'] = new_enduiryPeriod_endDate
    except: pass

    try:
        tenderPeriod_startDate = get_now_date()
        new_tenderPeriod_startDate = change_minute_in_date(tenderPeriod_startDate, minutes=int(tender_start))
        tender_data['data']['tenderPeriod']['startDate'] = new_tenderPeriod_startDate
    except: pass

    try:
        tenderPeriod_endDate = get_now_date()
        new_tenderPeriod_endDate = change_minute_in_date(tenderPeriod_endDate, minutes=int(tender_end))
        tender_data['data']['tenderPeriod']['endDate'] = new_tenderPeriod_endDate
    except: pass
    try:
        itemDelivery_startDate = get_now_date()
        new_itemDelivery_startDate = change_minute_in_date(itemDelivery_startDate, int(delirery_start), "plus")
        tender_data['data']['items'][0]['deliveryDate']['startDate'] = new_itemDelivery_startDate
    except: pass
    try:
        itemDelivery_endDate = get_now_date()
        new_itemDelivery_endDate = change_datetime(itemDelivery_endDate, int(delirery_end), "plus")
        tender_data['data']['items'][0]['deliveryDate']['endDate'] = new_itemDelivery_endDate
    except:
        pass
    return tender_data

def replace_data(data_path, func, **kwargs):
    old_data = data_path
    new_data = func(old_data,**kwargs)
    data_path = new_data

def get_now_date():
    ''' call -> str:date '''
    now = datetime.now()
    dt_string = now.strftime("%Y-%m-%dT%H:%M:%S.%f+03:00")
    return dt_string

def date_now_plus_minutes(minutes_count=0):
    now = get_now_date()
    result = change_minute_in_date(now, 0, int(minutes_count), plus=True)
    return result

def convert_string_date_to_obj(date_time_string):
    date_time_str = date_time_string[:10] + ' ' + date_time_string[11:26]
    date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S.%f')
    return date_time_obj

def change_datetime(date_time_str, count_day=int(0), calc="plus"):
    date_time_str = date_time_str[:10] + ' ' + date_time_str[11:-6]
    try:
        date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S.%f')
    except:
        date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S')
    
    delta = timedelta(days=count_day)
    if calc == "plus":
        new_date_time_obj = date_time_obj + delta
    elif calc == "minus":
        new_date_time_obj = date_time_obj - delta
    return new_date_time_obj.strftime('%Y-%m-%dT%H:%M:%S.%f+03:00')

def convert_date_to_valid_date(str_date):
    result_string = str_date[:10] + 'T' + str_date[11:] + '+02:00'
    return result_string.decode('utf-8', 'ignore')
