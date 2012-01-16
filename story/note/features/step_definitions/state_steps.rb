Given 'a new document' do
  @note = Note.open
end
When 'I exit the app' do
  @note.exit!
end
Then 'the app should be running' do
  @note.should be_running
end
