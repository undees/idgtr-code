# START:to_proc
class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end
# END:to_proc


# START:book_search
require 'rubygems'
require 'selenium'

class BookSearch
  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://www.pragprog.com', 10000
    @browser.start
  end
  
  def shutdown
    @browser.stop
  end
end
# END:book_search


# START:find  
class BookSearch
  ResultCounter = '//table[@id="bookshelf"]//tr'  #<callout id="co.xpath_const"/>
  ResultReader = 'xpath=/descendant::td[@class="description"]'

  def find(term)
    @browser.open '/'
    @browser.type  '//input[@id="q"]', term
    @browser.click '//button[@class="go"]'
    @browser.wait_for_page_to_load 5000
    
    num_results = @browser.get_xpath_count(ResultCounter).to_i

    (1..num_results).inject({}) do |results, i|
      title = @browser.get_text("#{ResultReader}[#{i}]/h4/a") #<callout id="co.use_xpath_const"/>
      by    = @browser.get_text("#{ResultReader}[#{i}]/p[@class='by-line']")
      url   = @browser.get_attribute("#{ResultReader}[#{i}]/h4/a@href")

      title, subtitle = title.split ': '
      authors = by.split(/by|and|,|with/).map(&:strip).reject(&:empty?) #<callout id="co.use_to_proc"/>
      
      results.merge title =>
      {
        :title => title,
        :subtitle => subtitle,
        :url => url,
        :authors => authors
      }
    end
  end
end
# END:find
