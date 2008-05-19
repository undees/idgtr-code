describe 'a new document', :shared => true do
  before do
    @note = Note.open
  end
  
  after do
    @note.exit! if @note.running?
  end
end
