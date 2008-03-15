# START:junquenote
require 'swing_gui'      #<callout id="co.swing_gui"/>
require 'junquenote_app'
require 'note'

class JunqueNote < Note
  include SwingGui

  # START:note_app
  @@app = JunqueNote
  @@titles[:save] = "Quittin' time"
  # END:note_app

  def initialize
    JunqueNoteApp.new

    @main_window = JFrameOperator.new 'JunqueNote'
    @edit_window = JTextAreaOperator.new @main_window #<callout id="co.edit_window"/>
  end
end
# END:junquenote


# START:text
class JunqueNote  
  def text
    @edit_window.text
  end
  
  def text=(message)
    @edit_window.clear_text
    @edit_window.type_text message
  end
end
# END:text
