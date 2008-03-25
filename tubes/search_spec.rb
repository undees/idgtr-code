describe 'Searching for Ruby' do
  predicate_matchers[:include] = :include?
  
  before :all do
    @search = BookSearch.new
    @results = @search.find 'Ruby'
  end
  
  after :all do
    @search.shutdown
  end
  
  it 'should find the Pickaxe book' do
    book = @results['Programming Ruby']
    book.should_not be_nil
    book[:authors].should include('Dave Thomas')
  end
  
  it 'should not find the Ajax book' do
    @results.should_not have_key('Pragmatic Ajax')
  end

  it 'should fail (on purpose) to find Dilbert' do
    @results.should have_key('Dilbert')
  end
end
