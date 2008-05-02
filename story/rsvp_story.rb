require 'rubygems'
require 'spec/story'
require 'chronic'
require 'party'

class Web
  attr_reader :browser
  
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
  end
  
  def run_ended
    @browser.stop
  end
  
  def method_missing(name, *args, &block)
    # no-op
  end
end

web = Web.new
browser = web.browser
Spec::Story::Runner.register_listener(web)

steps_for :rsvp do
  Given 'a link to a party' do
    @party = Party.new(browser)
    @party.name = 'Birthday'
    @party.save
    @link = @party.link
  end
  
  When 'I follow the link' do
    @rsvp = Rsvp.new browser, @link
  end
  
  When 'I enter my name' do
    @rsvp.name = 'someone'
    @rsvp.attending = true
    
    @my_name = 'My Name'
    @rsvp.name = @my_name
  end
  
  When 'I answer that I will attend' do
    @rsvp.attending = true
  end
  
  Then 'I should see the party details' do
    @rsvp.details
  end
  
  Then 'I should see my name in the list of partygoers' do
    @party.guests.include?(@my_name).should be_true
  end
end

with_steps_for :rsvp do
  run 'rsvp_story.txt'
end
