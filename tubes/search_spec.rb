require 'rubygems'
require 'selenium'

class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end

class Googler
  attr_reader :browser

  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://www.google.com', 10000
    @browser.start
  end
  
  def shutdown
    @browser.stop
  end
  
  ResultTag = "/descendant::h2[@class='r']"
  
  def find(term)
    @browser.open 'http://www.google.com'
    @browser.type 'name=q', term
    @browser.click 'name=btnG'
    @browser.wait_for_page_to_load 5000
    
    count = @browser.get_xpath_count(ResultTag).to_i
    puts count
    
    (1..count).collect do |i|
      xpath = "xpath=#{ResultTag}[#{i}]"
      [@browser.get_text(xpath),
       @browser.get_attribute(xpath + '/a@href')]
    end
  end
end


describe 'A search engine' do
  before :all do
    @googler = Googler.new
  end
  
  after :all do
    @googler.shutdown
  end
  
  it "should find what I'm looking for" do
    @googler.find('rspec').map(&:last).should include('http://rspec.info/')
  end
end
