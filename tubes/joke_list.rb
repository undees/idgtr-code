# START:joke_list
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
end
# END:joke_list


# START:move
class JokeList
  Reorder = '//a[@id="reorder"]'
  Draggable = 'selenium.browserbot.findElement("css=.drag").visible()' #<callout id="co.browserbot"/>
  Locked = '!' + Draggable

  def move(from_order, to_order)
    from_element = "//li[#{from_order}]/span[@class='drag']"
    to_element   = "//li[#{to_order}]/span[@class='drag']"

    @browser.click Reorder
    @browser.wait_for_condition Draggable, 2000 #<callout id="co.draggable"/>

    @browser.drag_and_drop_to_object from_element, to_element

    @browser.click Reorder
    @browser.wait_for_condition Locked, 2000    #<callout id="co.locked"/>
  end
end
# END:move


# START:order
class JokeList
  def order(item)
    @browser.get_element_index(item).to_i + 1
  end
end
# END:order
  

# START:items
class JokeList
  def items
    num_items = @browser.get_xpath_count('//li').to_i
    (1..num_items).map {|i| @browser.get_text "//li[#{i}]/span[2]"}
  end
end
# END:items
