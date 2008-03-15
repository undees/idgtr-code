require 'rubygems'
require 'spec/story'

steps_for :editing_text do
  Given 'a new document' do
    @note = Note.open
  end

  When 'I type "$something"' do |something|
    @note.text = something
  end  

  When 'I save the document as "$name" with password "$password"' do |name, password|
    @note.save_as name, :password => password
  end
  
  When 'I exit the app' do
    @note.exit!
  end

  When 'I open the document "$name" with password "$password"' do |name, password|
    @note = Note.open name, :password => password
  end

  When 'I change the password from "$old" to "$password"' do |old, password|
    @note.change_password :old_password => old, :password => password
  end

  Then 'the app should be running' do
    @note.should be_running
  end

  Then 'the text should equal "$something"' do |something|
    @note.text.should == something
  end

  Then 'the text should contain "$something"' do |something|
    @note.text.should include(something)
  end

  Then 'I exit the app' do
    @note.exit!
  end
end

# START:with_steps_for
with_steps_for :editing_text do
  run 'password_story.txt'
end
# END:with_steps_for
