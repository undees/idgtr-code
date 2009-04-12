Given /^a calculator$/ do
  @calc ||= Calculator.single
end

Given /^the following addition table:$/ do
  |params|

  rows = params.hashes
  header = rows.delete_at(0).keys.sort[1..-1]

  @cases = rows.inject([]) do |all, row|
    entries = header.reject {|n| row[n] == '-'}

    all + entries.inject([]) do |some, col|
      a      = number_for(col)
      b      = number_for(row['+'])
      result = number_for(row[col])

      some << [a, b, result]
    end
  end
end

When /^I start with a time of (\d+):(\d+):(\d+):(\d+)$/ do
  |days, hours, mins, secs|
  
  numbers = [days, hours, mins, secs].map {|s| s.to_i}

  @calc.clear
  @calc.enter_time *numbers
end

When /^I add (\d+):(\d+):(\d+):(\d+)$/ do
  |days, hours, mins, secs|
  
  numbers = [days, hours, mins, secs].map {|s| s.to_i}
  
  @calc.plus
  @calc.enter_time *numbers
  @calc.equals
end

Then /^each pair of numbers should add to the given value$/ do
  @cases.each do |a, b, expected|
    When "I start with a time of 00:00:00:#{a}"
    When "I add 00:00:00:#{b}"
    Then "the total number of seconds should be #{expected}"
  end
end

Then /^the time should be (\d+):(\d+):(\d+):(\d+)$/ do
  |days, hours, mins, secs|
  
  expected = [days, hours, mins, secs].map {|s| s.to_i}
  actual = @calc.time

  actual.should == expected
end

Then /^the total number of seconds should be (\d+)$/ do
  |secs|

  @calc.total_seconds.should == secs.to_i
end
