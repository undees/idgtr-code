$: << File.join(File.dirname(__FILE__), '../..')

require 'calculator'
require 'rubygems'
require 'spec'

class CalcWorld
  Constants = {:huge => 2**63 - 2, :huger => 2**63 - 1, :over => 0}

  def number_for(value)
    Constants[value.to_s.intern] || value.to_s.to_i
  end
end

World {CalcWorld.new}

at_exit {Calculator.single.off}
