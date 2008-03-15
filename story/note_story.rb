# START:steps_for
require 'rubygems'
require 'spec/story'

steps_for :editing_text do
  Given 'a new document' do
    @note = Note.open
  end

  When 'I paste the clipboard contents' do
    @note.paste
  end

  Then 'the text should equal "$something"' do |something|
    @note.text.should == something
  end
end
# END:steps_for

steps_for :editing_text do  
  When 'I type "$something"' do |something|
    @note.text = something
  end
  
  When 'I cut all the text' do
    @note.select_all
    @note.cut
  end

  When 'I select all the text' do
    @note.select_all
  end
  
  
  Then 'the text should be empty' do
    @note.text.should be_empty
  end
  
end

# START:with_steps_for
with_steps_for :editing_text do
  run 'note_story.txt'
end
# END:with_steps_for
