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
    @browser.close
  end

  Reorder = '//a[@id="reorder"]'
  Draggable = 'selenium.browserbot.findElement("css=.drag").visible()'
  
  def move_down(item, amount)
    drag_handle = "//li[@id='#{item}']/span[@class='drag']"
    
    @browser.click Reorder
    @browser.wait_for_condition Draggable, 1000
    @browser.drag_and_drop drag_handle, '+0, +150'
  end

  def drag_to(from_item, to_item)
    from = "//li[@id='#{from_item}']/span[@class='drag']"
    to   = "//li[@id='#{to_item}']/span[@class='drag']"
    
    @browser.click Reorder
    @browser.wait_for_condition Draggable, 1000
    @browser.drag_and_drop_to_object from, to
  end
  
  def position(item)
    @browser.get_element_index(item).to_i + 1
  end
end
