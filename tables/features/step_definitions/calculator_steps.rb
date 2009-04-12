Given /^a calculator$/ do
  @calc ||= Calculator.single
  @calc.clear
end

Given /^the following addition table:$/ do
  |params|

  @cases = []

  rows = params.hashes
  header = rows.delete_at(0)
  header.delete '+'

  rows.each do |row|
    header.keys.sort.each do |a|
      b = row['+']
      result = row[a]
      next if result == '-'

      @cases << [a, b, number_for(result)]
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

  @calc.enter_number number_for(a)
  @calc.plus
  @calc.enter_number number_for(b)
  @calc.equals

  @sums ||= []
  @sums << [a, b, @calc.total_seconds]
end

Then /^the results should match the table$/ do
  @sums.should == @cases
end
