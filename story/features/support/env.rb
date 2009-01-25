# START:browser
$LOAD_PATH.push File.dirname(__FILE__)

require 'rubygems'
require 'spec/expectations'
require 'chronic'

class PartyWorld
  @@browser = Selenium::SeleniumDriver.new \
    'localhost', 4444, '*firefox', 'http://localhost:3000', 10000
  @@browser.start
  at_exit {@@browser.stop}

  def browser; @@browser end
end

World do
  PartyWorld.new
end
# END:browser
