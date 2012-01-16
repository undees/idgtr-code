describe 'Searching for Ruby' do
  before :all do
    @search = BookSearch.new
    @results = @search.find 'Ruby'
  end

  after :all do
    @search.close
  end

  it 'should find the Pickaxe book' do
    book = @results['Programming Ruby 1.9 (3rd edition)']
    book.should_not be_nil
    book[:authors].should include('Dave Thomas')
  end

  it 'should not find the Ajax book' do
    @results.should_not have_key('Pragmatic Ajax')
  end

  it 'should fail (on purpose) to find Gilgamesh' do
    @results.should have_key('Gilgamesh') #<callout id="co.fail_on_purpose"/>
  end
end
