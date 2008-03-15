require 'java'
require 'jemmy.jar'
require 'junquenote_app'

include_class 'org.netbeans.jemmy.JemmyProperties'
include_class 'org.netbeans.jemmy.TestOut'

%w(Frame TextArea MenuBar Dialog Button).each do |o|
  include_class "org.netbeans.jemmy.operators.J#{o}Operator"
end

JemmyProperties.set_current_output TestOut.get_null_output
JemmyProperties.set_current_timeout 'DialogWaiter.WaitDialogTimeout', 3000


class Note
  def initialize
    JunqueNoteApp.new
    @main_window = JFrameOperator.new 'JunqueNote'

    puts "The main window's object ID is #{@main_window.object_id}."
  end

  def type_in(message)
    edit = JTextAreaOperator.new @main_window
    edit.type_text "this is some text"
  end

  # START:text
  def text
    edit = JTextAreaOperator.new @main_window #<callout id="co.edit_repeat"/>
    edit.text
  end
  # END:text

  def exit!
    menu = JMenuBarOperator.new @main_window
    menu.push_menu_no_block 'File|Exit', '|'

    dialog = JDialogOperator.new "Quittin' time"
    button = JButtonOperator.new dialog, "No"
    button.push
    
    @prompted = true
  rescue Exception => e
    puts e.inspect
  end

  def has_prompted?
    @prompted
  end
end
