require 'rubygems'
require 'selenium'

class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end

class BookSearch
  attr_reader :browser

  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://www.pragprog.com', 10000
    @browser.start
  end
  
  def shutdown
    @browser.stop
  end
  
  ResultCounter = '//table[@id="bookshelf"]//tr'
  ResultReader = 'xpath=/descendant::td[@class="description"]'
  
  def find(term)
    @browser.open '/'
    @browser.type  '//input[@id="q"]', 'Ruby'
    @browser.click '//button[@class="go"]'
    @browser.wait_for_page_to_load 5000
    
    num_results = @browser.get_xpath_count(ResultCounter).to_i
    (1..num_results).inject({}) do |results, i|
      title = @browser.get_text("#{ResultReader}[#{i}]/h4/a")
      by = @browser.get_text("#{ResultReader}[#{i}]/p[@class='by-line']")
      url = @browser.get_attribute("#{ResultReader}[#{i}]/h4/a@href")

      title, subtitle = title.split ': '
      authors = by.split(/by|and|,|with/).map(&:strip).reject(&:empty?)
      
      results.merge title => {
        :title => title,
        :subtitle => subtitle,
        :url => url,
        :authors => authors }
    end
  end
end


describe 'Searching for Ruby' do
  predicate_matchers[:include] = :include?
  
  before :all do
    @search = BookSearch.new
  end
  
  before :each do
    @results = @search.find 'Ruby'
  end
  
  after :all do
    @search.shutdown
  end
  
  it 'should find the Pickaxe book' do
    puts @results.inspect
    book = @results['Programming Ruby']
    book.should_not be_nil
    book[:authors].should include('Dave Thomas')
  end
  
  it 'should not find the Ajax book' do
    @results.should_not have_key('Pragmatic Ajax')
  end

  it 'should fail (on purpose) to find Dilbert' do
    @results.should have_key('Dilbert')
  end
end
