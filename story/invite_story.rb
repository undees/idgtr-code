require 'rubygems'
require 'spec/story'
require 'selenium'
require 'chronic'
require 'party'

steps_for :invite do
  Given 'a blank invitation' do
    @party = Party.new
  end
  
  When 'I plan a party called "$n"' do |name|
    @party.name = name
    @party.save
  end
  
  Then 'I should see the Web address to send to my friends' do
    @party.should have_link
  end

  Then 'the party should $a on $dt' do |action, datetime|
    from, to = @party.time
    actual_time = (action == 'begin') ? from : to
    expected_time = Chronic.parse(datetime)
    
    actual_time.should == expected_time
  end
end

with_steps_for :invite do
  run 'invite_story.txt'
end
