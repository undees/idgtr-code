# START:launch
require 'rubygems'
require 'selenium'

browser = Selenium::SeleniumDriver.new \
  'localhost', 4444, '*firefox', 'http://www.pragprog.com', 10000 #<callout id="co.firefox"/>
  
browser.start
browser.open 'http://www.pragprog.com'
# END:launch


# START:navigate
browser.type  '//input[@id="q"]', 'Ruby' #<callout id="co.selenium_name1"/>
browser.click '//button[@class="go"]'    #<callout id="co.selenium_name2"/>
browser.wait_for_page_to_load 5000
# END:navigate


# START:num_results
num_results = browser.get_xpath_count('table[@id="bookshelf"]/tr').to_i
# END:num_results


# START:results
(1..num_results).each do |n|
  selector = "xpath=/descendant::td[@class='description'][#{n}]/h4/a" #<callout id="co.result_n"/>
  title = browser.get_text(selector)
  link = browser.get_attribute(selector + '@href') #<callout id="co.result_href"/>
  
  puts 'Title: ' + title
  puts 'Link:  ' + link
  puts
end
# END:results
