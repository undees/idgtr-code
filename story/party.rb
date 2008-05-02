require 'rubygems'
require 'time'

class Party
  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://localhost:3000', 10000

    class << @browser
      def click_and_wait(link, ms = 5000)
        click link
        wait_for_page_to_load ms
      end
    end

    @browser.start
    @browser.open '/parties/new'
  end
  
  def name=(name)
    @browser.type 'id=party_name', name    
  end
  
  def save
    @browser.click_and_wait 'id=party_submit'    
  end
  
  def link
    @browser.get_text('id=party_link')
  end
  
  def has_link?
    link =~ %r(^http://)
  end
  
  def time
    ['party_begins_at', 'party_ends_at'].map do |id|
      Time.parse @browser.get_text("id=#{id}")
    end
  end
end
