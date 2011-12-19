# START:new_note
shared_context 'a new document' do            #<callout id="co.shared_true"/>
  before do                                   #<callout id="co.before_1"/>
    @note = Note.open
  end

  after do                                    #<callout id="co.after_1"/>
    @note.exit! if @note.running?             #<callout id="co.if_running"/>
  end
end
# END:new_note

# START:saved_note
shared_context 'a saved document' do
  before do
    Note.fixture 'SavedNote'                  #<callout id="co.use_fixture"/>
  end
end
# END:saved_note

# START:reopened_note
shared_context 'a reopened document' do
  before do
    @note = Note.open 'SavedNote'
  end

  after do
    @note.exit! if @note.running?
  end
end
# END:reopened_note

# START:searchable_document
shared_context 'a searchable document' do
  before do
    @sentence = 'The longest island is Isabel Island.'
    @term = 'Is'

    @first_match = @sentence.index(/Is/i)
    @second_match = @sentence.index(/Is/i, @first_match + 1)
    @reverse_match = @sentence.rindex(/Is/i)
    @word_match = @sentence.index(/Is\b/i)
    @case_match = @sentence.index(/Is/)

    @note.text = @sentence
  end
end
# END:searchable_document
