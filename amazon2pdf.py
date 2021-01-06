#!/usr/bin/env python3

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from fpdf import FPDF
import time

driver = webdriver.Firefox()
driver.set_window_size(820, 980)
driver.get("https://amazon.com")


# This section allows you to manually log in and set the screen to the first
# page of the kindle ebook
print("start logging in...")
for i in range(6, 0, -1):
    print(str(i*10) + " seconds left...")
    time.sleep(10)

# Start taking screenshots
actions = ActionChains(driver)
actions.send_keys(Keys.ARROW_RIGHT)
page_list = []
for i in range(217): #The number here completely depends on your resolution
    print("printing page " + str(i) + "...")
    fname = "page_" + str(i) + ".png"
    driver.save_screenshot(fname)
    page_list.append(fname)
    time.sleep(2)
    actions.perform()
    time.sleep(2)
driver.close()

# Stitch into pdf file
pdf = FPDF("P", "pt", [820, 980])
for page in page_list:
    print(page)
    pdf.add_page()
    pdf.image(page, 0, 0, 820, 980)
pdf.output("fresh_wind_fresh_fire.pdf", "F")
