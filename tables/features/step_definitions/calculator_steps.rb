Given /^a calculator$/ do
  @calc ||= Calculator.single
  @calc.clear
end

Given /^the following addition table:$/ do
  |params|

  @cases = []

  rows = params.hashes
  header = rows.delete_at(0).keys.sort[1..-1]

  rows.each do |row|
    entries = header.reject {|n| row[n] == '-'}

    entries.each do |name|
      a      = number_for(name)
      b      = number_for(row['+'])
      result = number_for(row[name])

      @cases << [a, b, result]
    end
  end
end

When /^I add each pair of numbers$/ do
  @sums = []
  @cases.map do |a, b, result|
    When "I add #{a} seconds and #{b} seconds"
  end
end

When /^I add (.+) seconds and (.+) seconds$/ do
  |a, b|

  a, b = [a.to_i, b.to_i]

  @calc.enter_number a
  @calc.plus
  @calc.enter_number b
  @calc.equals
  result = @calc.total_seconds

  @sums ||= []
  @sums << [a, b, result]
end

Then /^the results should match the table$/ do
  @sums.should == @cases
end
