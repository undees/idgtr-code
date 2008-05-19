# START:party_settings
require 'rubygems'
require 'selenium'
require 'time'

class Party
  def initialize(browser)
    @browser = browser
    @browser.open '/parties/new'
  end

  def Party.def_setting(setting, type = :read_write)
    if type == :readable || type == :read_write
      define_method(setting) do
        @browser.get_text("id=party_#{setting}")
      end
    end
    
    if type == :writable || type == :read_write
      define_method(setting.to_s + '=') do |value|
        @browser.type "id=party_#{setting}", value
      end
    end
  end

  def_setting :name
  def_setting :description
  def_setting :location
  def_setting :link, :readable
  def_setting :notice, :readable
  def_setting :recipients, :writable
end
# END:party_settings


# START:party_set_time
class Party  
  def begins_at=(time); set_time(:begin, time) end
  def ends_at=  (time); set_time(:end, time) end

  def set_time(event, time)
    ['%Y', '%B', '%d', '%H', '%M'].each_with_index do |part, index|
      element = "id=party_#{event}s_at_#{index + 1}i"
      value = time.strftime part
      
      @browser.select element, value
    end
  end
end
# END:party_set_time


# START:party_get_time
class Party  
  def begins_at; get_times.first end
  def ends_at; get_times.last end

  def get_times
    begins_on = @browser.get_text 'party_begins_on'
    begins_at = @browser.get_text 'party_begins_at'
    ends_at = @browser.get_text 'party_ends_at'
    
    begins = Time.parse(begins_on + ' ' + begins_at)
    ends = Time.parse(begins_on + ' ' + ends_at)
    ends += 86400 if ends < begins
    
    [begins, ends]
  end
end
# END:party_get_time


# START:party_save
class Party
  def save_and_view
    @browser.click 'id=party_submit'
    @browser.wait_for_page_to_load 5000
    @saved = true
  end
end
# END:party_save


# START:rsvp
class Party
  def rsvp(name, attending)
    @browser.type 'guest_name', name
    @browser.click 'guest_attending' unless attending
    @browser.click 'rsvp'
    @browser.wait_for_page_to_load 5000
  end
end
# END:rsvp


# START:responses
class Party
  RsvpItem = '//ul[@id="guests"]/li'
  
  def responses(want_attending)
    num_guests = @browser.get_xpath_count(RsvpItem).to_i
    return [] unless num_guests >= 1

    all = (1..num_guests).map do |i|
      name = @browser.get_text \
        "#{RsvpItem}[#{i}]/span[@class='rsvp_name']"
      rsvp = @browser.get_text \
        "#{RsvpItem}[#{i}]/span[@class='rsvp_attending']"
      [name, rsvp]
    end
    
    matching = all.select do |name, rsvp|
      is_attending = !rsvp.include?('not')
      !(want_attending ^ is_attending)
    end
    
    matching.map {|name, rsvp| name}
  end
end
# END:responses


# START:party_email
class Party
  def email_to(address)
    @browser.open link + '.txt?email=' + address
    @browser.get_body_text
  end

  def rsvp_at(rsvp_link)
    @browser.open rsvp_link
  end
end
# END:party_email