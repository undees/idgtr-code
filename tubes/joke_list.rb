require 'rubygems'
require 'selenium'

class JokeList
  def initialize
    @browser = Selenium::SeleniumDriver.new \
      'localhost', 4444, '*firefox', "http://localhost:8000", 10000

    @browser.start
    @browser.open 'http://localhost:8000/dragdrop.html'
  end
  
  def close
    @browser.stop
  end

  Reorder = '//a[@id="reorder"]'
  Draggable = 'selenium.browserbot.findElement("css=.drag").visible()'
  
  def move(from_pos, to_pos)
    from = "//li[#{from_pos}]/span[@class='drag']"
    to   = "//li[#{to_pos}]/span[@class='drag']"
    
    @browser.click Reorder
    @browser.wait_for_condition Draggable, 1000
    @browser.drag_and_drop_to_object from, to
    @browser.click Reorder
  end
  
  def position(item)
    @browser.get_element_index(item).to_i + 1
  end
  
  def items
    num_items = @browser.get_xpath_count('//li').to_i
    (1..num_items).map {|i| @browser.get_text "//li[#{i}]/span[2]"}
  end
end
