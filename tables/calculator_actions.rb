# START:calculator_actions
require 'fit/fixture'
require 'calculator'

class CalculatorActions < Fit::Fixture
  def initialize
    @calc = Calculator.single
  end
  
  def number(value)
    @calc.enter_number value
  end
  
  [:plus, :equals, :total_seconds].each do |name|
    define_method(name) do
      @calc.send name
    end
  end
end
# END:calculator_actions