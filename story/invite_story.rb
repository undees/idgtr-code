require 'rubygems'
require 'spec/story'
require 'selenium'
require 'chronic'
require 'time'

steps_for :invite do
  Given 'a blank invitation' do
    @subitted = false
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
  
  When 'I plan a party called "$n"' do |name|
    @browser.type 'id=party_name', name    
  end
  
  Then 'I should see the Web address to send to my friends' do
    @submitted ||= @browser.click_and_wait 'id=party_submit'
    @browser.get_text('id=party_link').should match(%r(^http://))
  end

  Then 'the party should $a on $dt' do |action, datetime|
    @submitted ||= @browser.click_and_wait 'id=party_submit'

    id = "party_#{action}s_at"
    actual_time = Time.parse @browser.get_text("id=#{id}")
    expected_time = Chronic.parse(datetime)
    
    actual_time.should == expected_time
  end
end

with_steps_for :invite do
  run 'invite_story.txt'
end