require 'rubygems'
require 'selenium'
require 'time'

class Party
  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', 'http://localhost:3000', 10000
    @browser.start
    @browser.open '/parties/new'
  end
  
  def close
    @browser.stop
  end
  
  def name=(name)
    @browser.type 'id=party_name', name    
  end
  
  def view
    ensure_saved
    @browser.open link
  end
  
  def ensure_saved
    unless @saved
      @browser.click 'id=party_submit'
      @browser.wait_for_page_to_load 5000
      @saved = true
    end
  end
  
  def link
    ensure_saved
    @browser.get_text('id=party_link')
  end
  
  def has_link?
    ensure_saved
    link =~ %r(^http://)
  end
  
  def time
    begins_on = @browser.get_text 'party_begins_on'
    begins_at = @browser.get_text 'party_begins_at'
    ends_at = @browser.get_text 'party_ends_at'
    
    begins = Time.parse(begins_on + ' ' + begins_at)
    ends = Time.parse(begins_on + ' ' + ends_at)
    ends += 86400 if ends < begins
    
    [begins, ends]
  end
  
  RsvpItem = '//ul[@id="guests"]/li'
  
  def guests
    num_guests = @browser.get_xpath_count(RsvpItem).to_i
    puts
    puts num_guests
    (1..num_guests).map do |i|
      puts i
      puts @browser.get_text("#{RsvpItem}[#{i}]/span[@class='rsvp_name']")
      @browser.get_text "#{RsvpItem}[#{i}]/span[@class='rsvp_name']"
    end
  end
end


class Rsvp
  def initialize(browser, link)
    @browser = browser
    @link = link
    @browser.open @link
  end
  
  def details
    fields = %w(name description location begins_at ends_at)
    fields.each do |f|
      @browser.get_text "party_#{f}"
    end
  end
  
  def name=(name)
    @browser.type 'guest_name', name
  end
  
  def attending=(attending)
    @browser.click_and_wait 'rsvp'
  end
end
