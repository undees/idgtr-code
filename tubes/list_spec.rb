require 'joke_list'

describe JokeList do
  before do
    @list = JokeList.new
  end

  after do
    @list.close
  end

  # START:simple
  it 'lets me drag an item to the end' do
    @list.position('doctor').should == 2
    @list.move 2, 5
    @list.position('doctor').should == 5
  end
  # END:simple
  
  # START:sort
  it 'lets me drag multiple items to sort' do
    original = @list.items
    
    original.length.downto(1) do |last_pos|
      subset = @list.items[0..last_pos - 1]
      max_pos = subset.index(subset.max) + 1
      @list.move max_pos, last_pos
    end
    
    @list.items.should == original.sort
  end
  # END:sort
end
