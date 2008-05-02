require 'rubygems'
require 'selenium'
require 'time'

class Party
  def initialize(browser)
    @browser = browser
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
