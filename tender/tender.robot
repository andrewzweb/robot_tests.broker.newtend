** Settings ***
# default
Library  String
Library  DateTime

# services
Library  ../helper/newtend_service.py

# helper
Resource  ../helper/locators.robot
Resource  ../helper/helper.robot
Resource  ../helper/data.robot

# tender
Resource  tender_create.robot  
Resource  tender_edit.robot
Resource  tender_get.robot
Resource  tender_helper.robot
Resource  tender_locators.robot
