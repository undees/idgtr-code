describe 'RSpec' do
  it 'supports writing clear tests' do
# START:should
    (2 + 2).should == 4
    1.should be < 2
    ['this', 'list'].should_not be_empty
    {:color => 'red'}.should have_key(:color)
# END:should
  end
end