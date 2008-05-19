# START:browser
require 'rubygems'
require 'spec/story'
require 'chronic'
require 'party'

$browser = Selenium::SeleniumDriver.new \
  'localhost', 4444, '*firefox', 'http://localhost:3000', 10000
$browser.start

class << $browser
  def run_ended #<callout id="co.run_ended"/>
    stop
  end
  
  def method_missing(name, *args, &block)
    # This space intentionally left blank.
  end
end

Spec::Story::Runner.register_listener($browser)  #<callout id="co.register_listener"/>
# END:browser


# START:planning
steps_for :planning do
  Given 'a party called "$name"' do |name|
    @party = Party.new($browser)
    @party.name = name
  end

  Given 'a description of "$desc"' do |desc|
    @party.description = desc
  end
  
  Given 'a location of "$loc"' do |loc|
    @party.location = loc
  end
  
  Given /an? $event time of $sometime/ do |event, sometime|   #<callout id="co.step_regex"/>
    clean = sometime.gsub ',', ' '
    date_time = Chronic.parse clean, :now => Time.now - 86400 #<callout id="co.chronic"/>

    if event == 'starting'
      @party.begins_at = date_time
    else
      @party.ends_at = date_time
    end
  end

  When 'I view the invitation' do
    @party.save_and_view
  end
end
# END:planning


# START:reviewing
steps_for :reviewing do
  Then 'the $setting should be "$value"' do |setting, value|
    @party.send(setting).should == value
  end

  Then 'the party should $event on $date_time' do |event, date_time|
    actual_time =
      (event == 'begin') ?
      @party.begins_at :
      @party.ends_at

    clean = date_time.gsub ',', ' '
    expected_time = Chronic.parse clean, :now => Time.now - 86400
    
    actual_time.should == expected_time
  end
  
  Then 'I should see the Web address to send to my friends' do
    @party.link.should match(%r{^http://})
  end
end
# END:reviewing


# START:rsvp
steps_for :rsvp do
  Then 'I should see the party details' do
    # Any of these will throw an exception
    # if novite fails to show the relevant detail.
    @party.name
    @party.description
    @party.location
    @party.begins_at
    @party.ends_at
  end
  
  When /I answer that "$guest" will( not)? attend/ do |guest, answer|
    attending = !answer.include?('not')
    @party.rsvp guest, attending
  end

  Then 'I should see "$guest" in the list of $type' do |guest, type|
    want_attending = (type == 'partygoers')
    @party.responses(want_attending).include?(guest).should be_true
  end
end
# END:rsvp


# START:email
steps_for :email do
  Given 'a guest list of "$list"' do |list|
    @party.recipients = list
  end
  
  Then 'I should see that e-mail was sent to "$list"' do |list|
    @party.notice.include?(list).should be_true
  end

  When 'I view the e-mail that was sent to "$address"' do |address|
    @email = @party.email_to address
  end
  
  Then 'I should see "Yes/No" links' do
    @email.should match(%r{Yes - http://})
    @email.should match(%r{No - http://})
  end
  
  When 'I follow the "$answer" link' do |answer|
    link = %r{#{answer} - (http://.+)}.match(@email)[1]
    @party.rsvp_at link
  end
end
# END:email


# START:with_steps_for
with_steps_for :planning, :reviewing do
  run 'invite_story.txt'
end
# END:with_steps_for


# START:with_steps_for_rsvp
with_steps_for :planning, :reviewing, :rsvp, :email do
  run 'rsvp_story.txt'
end
# END:with_steps_for_rsvp
