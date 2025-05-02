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
if(settings['headless']):
    chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36")
chrome_options.add_argument("--disable-blink-features=AutomationControlled") 
chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"]) 
chrome_options.add_experimental_option("useAutomationExtension", False) 

driver = webdriver.Chrome(options=chrome_options)
driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})") 
try:
    driver.get("https://www.myrta.com/wps/portal/extvp/myrta/login/")
    driver.find_element(By.ID,"widget_cardNumber").send_keys(settings['username'])
    driver.find_element(By.ID,"widget_password").send_keys(settings['password'])
    time.sleep(settings['wait_timer'])
    driver.find_element(By.ID,"nextButton").click()
    if(settings['have_booking']):
        driver.find_element(By.XPATH,'//*[text()="Manage booking"]').click()
        driver.find_element(By.ID,"changeLocationButton").click()
        time.sleep(settings['wait_timer'])
    else:
        driver.find_element(By.XPATH,'//*[text()="Book test"]').click()
        time.sleep(settings['wait_timer_car'])
        driver.find_element(By.ID,"CAR").click()
        time.sleep(settings['wait_timer_car'])
        driver.find_element(By.XPATH,"//fieldset[@id='DC']/span[contains(@class, 'rms_testItemResult')]").click()
        time.sleep(settings['wait_timer'])
        driver.find_element(By.ID,"nextButton").click()
        time.sleep(settings['wait_timer'])
        driver.find_element(By.ID,"checkTerms").click()
        time.sleep(settings['wait_timer'])
        driver.find_element(By.ID,"nextButton").click()
        time.sleep(settings['wait_timer'])
        driver.find_element(By.ID,"rms_batLocLocSel").click()
        time.sleep(settings['wait_timer'])
    driver.find_element(By.ID,"rms_batLocLocSel").click()
    time.sleep(settings['wait_timer'])
    select_box = driver.find_element(By.ID,"rms_batLocationSelect2")
    Select(select_box).select_by_value(sys.argv[1])
    time.sleep(settings['wait_timer'])
    driver.find_element(By.ID,"nextButton").click()
    if(driver.find_element(By.ID,"getEarliestTime").size!=0):
        if(driver.find_element(By.ID,"getEarliestTime").is_displayed()):
            if(driver.find_element(By.ID,"getEarliestTime").is_enabled()):
                driver.find_element(By.ID,"getEarliestTime").click()
    result = driver.execute_script('return timeslots')
    results_file = open(sys.argv[2],"a")
    results_file.write('{"location":"'+sys.argv[1]+'","result":'+json.dumps(result)+'}\n')
    results_file.close()
    driver.quit()
except:
    driver.quit()
    exit(1)
