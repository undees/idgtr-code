require 'joke_list'

describe JokeList do
  before do
    @list = JokeList.new
  end

  after do
    @list.close
  end

  it 'lets me reorder by dragging' do
    @list.position('joke_1').should == 1
    @list.drag_to('joke_1', 'joke_4')
    @list.position('joke_1').should == 4
  end
end
