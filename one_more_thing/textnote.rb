# START:textnote
require 'applescript'
require 'note'

class TextNote < Note
  include AppleScript

  @@app = TextNote

  def initialize(name = 'Untitled', with_options = {})
    tell.application('TextEdit').activate!
    tell.application('TextEdit').make_new_document!
  end

  DontSave = 3

  def exit!
    menu 'File', 'Close'
    sleep 1
    tell.
      application('System Events').
      process('TextEdit').
      window('Untitled').
      sheet(1).
      click_button!(DontSave) #<callout id="co.click_button_2"/>

    menu 'TextEdit', 'Quit TextEdit'
  end

  def running?
    tell.
      application('System Events').
      process!('TextEdit').include?('TextEdit') #<callout id="co.textnote_running"/>
  end
end
# END:textnote


# START:text
class TextNote
  def text
    tell.
      application('System Events').
      process('TextEdit').
      window('Untitled').
      scroll_area(1).
      text_area(1).
      get_value!
  end
  def text=(new_text)
    select_all
    tell.application('System Events').
      process('TextEdit').
      window('Untitled') do
        new_text.split(//).each {|k| keystroke! k}
      end
  end
end
# END:text


# START:menu
class TextNote
  def menu(name, item, wait = false)
    tell.application('System Events').
      process('TextEdit').
      menu_bar(1).
      menu_bar_item(name).
      menu(name).
      click_menu_item! item
  end
  def undo; menu('Edit', 1) end #<callout id="co.textnote_undo"/>
  def select_all; menu('Edit', 'Select All') end
  def cut; menu('Edit', 'Cut') end
  def copy; menu('Edit', 'Copy') end
  def paste; menu('Edit', 'Paste') end
end
# END:menu
