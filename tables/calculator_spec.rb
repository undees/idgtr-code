require 'calculator'

describe 'a new calculator', :shared => true do
  before do
    @calc = Calculator.single
    @calc.clear
  end
end

module AdditionHelper
  def add_and_check(number, result)
    @calc.enter_number number
    @calc.equals
    @calc.total_seconds.should == result
  end
end

# START:verbose_spec
describe 'Starting with 1' do
  include AdditionHelper
  
  it_should_behave_like 'a new calculator'
  
  before do
    @calc.enter_number 1
    @calc.plus
  end

  it 'should add 0 correctly' do
    add_and_check(0, 1)
  end
  
  it 'should add 1 correctly' do
    add_and_check(1, 2)
  end
  
  # two more nearly-identical examples
end
# END:verbose_spec
