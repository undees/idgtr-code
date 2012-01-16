Given /^a party called "(.*)"$/ do |name|
  @party = Party.new(browser)
  @party.name = name
end

Given /^a description of "(.*)"$/ do |desc|
  @party.description = desc
end

Given /^a location of "(.*)"$/ do |loc|
  @party.location = loc
end

Given /an? (.*) time of (.*)/ do |event, sometime|   #<callout id="co.step_regex"/>
  clean = sometime.gsub ',', ' '
  date_time = Chronic.parse clean, :now => Time.now - 86400 #<callout id="co.chronic"/>

  if event == 'starting'
    @party.begins_at = date_time
  else
    @party.ends_at = date_time
  end
end

When /^I view the invitation$/ do
  @party.save_and_view
end
