require 'calculator'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'fit/parse'
require 'fit/file_runner'

report = ARGV[1]
unless report.nil?
  Fit::Parse.footnote_path = File.dirname(report) + File::SEPARATOR
end

# START:calc_runner
class CalcRunner < Fit::FileRunner
  def run(args)
    process_args args
    process
    $stderr.puts @fixture.totals
    Calculator.single.off # will exit
  end
end

CalcRunner.new.run(ARGV)
# END:calc_runner