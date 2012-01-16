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
num_results = browser.get_xpath_count('//table[@id="bookshelf"]//tr').to_i
# END:num_results


# START:results
results = (1..num_results).map do |n|
  element  = "xpath=/descendant::td[@class='description'][#{n}]/h4/a" #<callout id="co.result_n"/>
  title    = browser.get_text(element)
  url      = browser.get_attribute(element + '@href') #<callout id="co.result_href"/>

  {:title => title, :url => url, :element => element}
end

results.each do |r|
  puts 'Title: ' + r[:title]
  puts 'Link:  ' + r[:url]
  puts
end
# END:results


# START:details
pickaxe = results.find {|r| r[:title].include? 'Programming Ruby 1.9'}
browser.click pickaxe[:element]
browser.wait_for_page_to_load 5000
# END:details


# START:purchase
browser.click '//button[@class="add-to-cart"]'
browser.wait_for_page_to_load 5000

browser.click '//button[@id="check-out-button"]' # redirects to https
browser.wait_for_page_to_load 5000
# END:purchase
