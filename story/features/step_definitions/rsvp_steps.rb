Then /^I should see the party details$/ do
  @party.should have_name
  @party.should have_description
  @party.should have_location
  @party.should have_times
end

When /I answer that "(.*)" will( not)? attend/ do |guest, answer|
  attending = !answer.include?('not')
  @party.rsvp guest, attending
end

Then /^I should see "(.*)" in the list of (.*)$/ do |guest, type|
  want_attending = (type == 'partygoers')
  @party.responses(want_attending).should include(guest)
end
