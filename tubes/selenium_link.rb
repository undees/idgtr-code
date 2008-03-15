require 'rubygems'
require 'selenium'

# START:browser
browser = Selenium::SeleniumDriver.new \
  'localhost', 4444, '*chrome', 'http://www.pragprog.com', 10000
# END:browser

browser.start

# START:offsite
browser.open 'http://www.pragprog.com/community'
browser.click '//div[text()="Dojo Foundation"]/following-sibling::ul/li/a'
browser.wait_for_page_to_load 5000
# END:offsite
