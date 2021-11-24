#! /usr/local/bin/python3

import sys
import time
import json
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.chrome.options import Options


settings = json.load(open("settings.json"))
chrome_options = Options()
chrome_options.add_argument("--headless")
driver = webdriver.Chrome(options=chrome_options)

driver.get("https://www.myrta.com/wps/myportal/extvp/myrta/")
driver.find_element(By.ID,"widget_cardNumber").send_keys(settings['username'])
driver.find_element(By.ID,"widget_password").send_keys(settings['password'])
time.sleep(1)
driver.find_element(By.ID,"nextButton").click()
driver.find_element(By.XPATH,'//*[text()="Manage booking"]').click()
driver.find_element(By.ID,"changeLocationButton").click()
time.sleep(1)
driver.find_element(By.ID,"rms_batLocLocSel").click()
time.sleep(1)
select_box = driver.find_element(By.ID,"rms_batLocationSelect2")
Select(select_box).select_by_value(sys.argv[1])
time.sleep(1)
driver.find_element(By.ID,"nextButton").click()
earliest_time = driver.find_element(By.ID,"getEarliestTime")
if(earliest_time.size!=0 and earliest_time.is_displayed() and earliest_time.is_enabled()):
    earliest_time.click()

result = driver.execute_script('return timeslots')
results_file = open("results.json","a")
results_file.write('{"location":"'+sys.argv[1]+'","result":'+json.dumps(result)+'}\n')
results_file.close()
driver.find_element(By.ID,"anotherLocationLink").click()
driver.quit()
