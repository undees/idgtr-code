require 'rubygems'
require 'selenium'


describe 'A search engine' do
  before :all do
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://www.google.com', 10000
    @browser.start
  end
  
  before :each do
    @browser.open 'http://www.google.com'
  end
  
  after :all do
    @browser.stop
  end
  
  it "should find what I'm looking for" do
    @browser.type 'name=q', 'rspec'
    @browser.click 'name=btnG'
    @browser.wait_for_page_to_load 5000

    link_text = @browser.get_text "xpath=//h2[@class='r']/a"
    link_text.should include('RSpec')
  end
end
