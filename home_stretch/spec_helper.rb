# START:new_note
describe 'a new document', :shared => true do #<callout id="co.shared_true"/>
  before do                                   #<callout id="co.before_1"/>
    @note = Note.open
  end
  
  after do                                    #<callout id="co.after_1"/>
    @note.exit! if @note.running?             #<callout id="co.if_running"/>
  end
end
# END:new_note

# START:saved_note
describe 'a saved document', :shared => true do
  before do
    Note.fixture 'SavedNote'                  #<callout id="co.use_fixture"/>
  end
end
# END:saved_note

# START:reopened_note
describe 'a re-opened document', :shared => true do  
  before do
    @note = Note.open 'SavedNote'
  end
  
  after do
    @note.exit! if @note.running?
  end
end  
# END:reopened_note

# START:searchable_document
describe 'a searchable document', :shared => true do
  before do
    @example = 'The longest island is Isabel Island.'
    @term = 'Is'

    @first_match = @example.index(/Is/i)
    @second_match = @example.index(/Is/i, @first_match + 1)
    @reverse_match = @example.rindex(/Is/i)
    @word_match = @example.index(/Is\b/i)
    @case_match = @example.index(/Is/)    

    @note.text = @example
  end
end
# END:searchable_document