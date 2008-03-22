require 'rubygems'
require 'selenium'

browser = Selenium::SeleniumDriver.new \
  'localhost', 4444, '*firefox', "http://localhost:8000", 10000
  
browser.start
browser.open "http://localhost:8000/dragdrop.html"
browser.click "//a[@id='reorder']"

puts browser.get_element_index('item_1')

can_drag = %q{selenium.browserbot.findElement("css=.drag").visible()}
browser.wait_for_condition can_drag, 1000

browser.drag_and_drop 'css=.drag', '+0, +150'
puts browser.get_element_index('item_1')
