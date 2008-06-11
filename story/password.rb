# START:app_state
require 'rubygems'
require 'spec/story'

steps_for :app_state do #<callout id="co.steps_for"/>
  Given 'a new document' do
    @note = Note.open
  end

  When 'I exit the app' do
    @note.exit!
  end

  Then 'the app should be running' do
    @note.should be_running
  end
end
# END:app_state


# START:documents
steps_for :documents do
  When 'I type "$something"' do |something|
    @note.text = something
  end  

  When 'I save the document as "$name" with password "$password"' do  #<callout id="co.when_parameter"/>
    |name, password|
    @note.save_as name, :password => password
  end
  
  When 'I open the document "$name" with password "$password"' do
    |name, password|
    @note = Note.open name, :password => password
  end

  When 'I change the password from "$old" to "$password"' do
    |old, password|
    @note.change_password :old_password => old, :password => password
  end

  Then 'the text should be "$something"' do |something|
    @note.text.should == something
  end
end
# END:documents


# START:with_steps_for
with_steps_for :app_state, :documents do
  run 'password.story'
end
# END:with_steps_for
