require 'rubygems'

# START:require_zentest
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'functional_test_matrix'

Test::Unit::TestCase.extend FunctionalTestMatrix
# END:require_zentest


# START:test_class
require 'calculator'

class CalculatorTest < Test::Unit::TestCase
  def setup
    @calc ||= Calculator.single #<callout id="co.calc_single"/>
    @calc.clear
  end
end
# END:test_class


# START:matrix_methods
class CalculatorTest
  Constants = {:huge => 2**63 - 2, :huge_1 => 2**63 - 1, :over => 0}

  def number_for(value) #<callout id="co.number_for"/>
    Constants[value.to_s.intern] || value.to_s.to_i
  end

  def matrix_init_addition(_, value)
    @seconds = number_for value
    @calc.enter_number @seconds
  end

  def matrix_setup_add(value)
    @adding = number_for value

    @calc.plus
    @calc.enter_number @adding
    @calc.equals
  end

  def matrix_test(expected)
    assert_equal @calc.total_seconds, number_for(expected)
  end
end
# END:matrix_methods


# START:method_missing
class CalculatorTest
  alias_method :old_method_missing, :method_missing

  def method_missing(name, *args)
    case name.to_s
    when /matrix_setup_add_(.+)/
      matrix_setup_add $1
    when /matrix_test_(.+)/
      matrix_test $1
    else
      old_method_missing name, *args
    end
  end
end
# END:method_missing


# START:matrix
class CalculatorTest
  matrix :addition, :to_0,   :to_1,    :to_2, :to_huge
  action :add_0,     0,      1,        2,     :huge
  action :add_1,     1,      2,        3,     :huge_1
  action :add_2,     2,      3,        4,     :over
  action :add_huge,  :huge,  :huge_1,  :over, :over
end
# END:matrix


# START:horror_vacui
class CalculatorTest
  _ = :na

  matrix :addition, :to_0,   :to_1,    :to_2, :to_huge
  action :add_0,     0,      _,        _,     _
  action :add_1,     1,      2,        _,     _
  action :add_2,     2,      3,        4,     _
  action :add_huge,  :huge,  :huge_1,  :over, :over
end
# END:horror_vacui


# START:calc_off
Test::Unit::UI::Console::TestRunner.run(CalculatorTest)

Calculator.single.off
# END:calc_off
