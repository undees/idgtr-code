# START:capture
require 'rspec/core/formatters/html_formatter'
RSpec.configure do |config|
  config.before :all do
    $example_num = 1
  end
  config.after do
    `osascript -e 'tell application "Firefox" to activate'`
    `screencapture #{$example_num}.png` #<callout id="co.screencapture"/>
    $example_num += 1
  end
end
# END:capture


# START:formatter
class HtmlCapture < RSpec::Core::Formatters::HtmlFormatter
  def extra_failure_content(failure)
    img = %Q(<img src="#{example_number}.png"
                  alt="" width="25%" height="25%" />)
    super(failure) + img
  end
end
# END:formatter
