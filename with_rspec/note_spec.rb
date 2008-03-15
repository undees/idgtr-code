describe 'The main window' do
  # START:launch
  it 'launches with a welcome message' do
    note = Note.new                     #<callout id="co.new"/>
    note.text.should include('Welcome') #<callout id="co.welcome"/>
    note.exit!                          #<callout id="co.exit"/>
  end
  # END:launch
  
  # START:exit
  it 'exits without a prompt if nothing has changed' do
    note = Note.new
    note.exit!
    note.should_not have_prompted
  end
  
  it 'prompts before exiting if the document has changed' do
    note = Note.new
    note.type_in "changed"
    note.exit!
    note.should have_prompted
  end
  # END:exit
end
