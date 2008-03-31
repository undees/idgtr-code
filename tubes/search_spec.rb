describe 'Searching for Ruby' do
  predicate_matchers[:include] = :include? #<callout id="co.predicate_matchers"/>
  
  before :all do
    @search = BookSearch.new
    @results = @search.find 'Ruby'
  end
  
  after :all do
    @search.close
  end
  
  it 'should find the Pickaxe book' do
    book = @results['Programming Ruby']
    book.should_not be_nil
    # START:use_matcher
    book[:authors].should include('Dave Thomas')
    # END:use_matcher
  end
  
  it 'should not find the Ajax book' do
    @results.should_not have_key('Pragmatic Ajax')
  end

  it 'should fail (on purpose) to find Gilgamesh' do
    @results.should have_key('Gilgamesh') #<callout id="co.fail_on_purpose"/>
  end
end
