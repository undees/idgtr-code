# START:reviewing
Then /^the (.*) should be "(.*)"$/ do |setting, value|
  @party.send(setting).should == value
end

Then /^the party should (.*) on (.*)$/ do |event, date_time|
  actual_time =
    (event == 'begin') ?
    @party.begins_at :
    @party.ends_at

  clean = date_time.gsub ',', ' '
  expected_time = Chronic.parse clean, :now => Time.now - 86400
  
  actual_time.should == expected_time
end

Then /^I should see the Web address to send to my friends$/ do
  @party.link.should match(%r{^http://})
end
# END:reviewing
