require 'spec_helper'

describe 'The editor' do
  it_should_behave_like 'a new document'

  it 'supports multiple levels of undo' do
    # START:undo
    @note.text = 'abc'
    @note.text = 'def'
    
    @note.undo
    @note.text.should == 'abc'

    @note.undo
    @note.text.should be_empty
    # END:undo
  end
  
  it 'supports copying and pasting text' do
    @note.text = 'itchy'
    @note.select_all
    @note.copy
    @note.text.should == 'itchy'
    
    @note.text = 'scratchy'
    @note.select_all
    @note.paste
    @note.text.should == 'itchy'
  end
  
  it 'supports cutting and pasting text' do
    @note.text = 'pineapple'
    @note.select_all
    @note.cut
    @note.text.should be_empty
    
    @note.text = 'mango'
    @note.select_all
    @note.paste
    @note.text.should == 'pineapple'
  end
end
