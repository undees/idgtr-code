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
