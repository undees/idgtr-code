shared_context 'a new document' do
  before do
    @note = Note.open
  end

  after do
    @note.exit! if @note.running?
  end
end
