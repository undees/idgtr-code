# START:capture
require 'spec/runner/formatter/html_formatter'

Spec::Runner.configure do |config|
  config.before :all do
    $example_num = 1
  end

  config.after do
    `screencapture #{$example_num}.png` #<callout id="co.screencapture"/>
    $example_num += 1
  end
end
# END:capture


# START:formatter
class HtmlCapture < Spec::Runner::Formatter::HtmlFormatter
  def extra_failure_content(failure)
    img = %Q(<img src="#{current_example_number}.png"
                  alt="" width="25%" height="25%" />)
    super(failure) + img
  end
end
# END:formatter
