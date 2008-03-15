# START:launch
require 'java'
require 'jemmy.jar'
require 'junquenote_app'

include_class 'org.netbeans.jemmy.JemmyProperties'
include_class 'org.netbeans.jemmy.TestOut'

%w(Frame TextArea MenuBar Dialog Button).each do |o| #<callout id="co.include_each"/>
  include_class "org.netbeans.jemmy.operators.J#{o}Operator"
end

JemmyProperties.set_current_timeout 'DialogWaiter.WaitDialogTimeout', 3000 #<callout id="co.jemmy_timeout"/>
JemmyProperties.set_current_output TestOut.get_null_output #<callout id="co.jemmy_output"/>

JunqueNoteApp.new
main_window = JFrameOperator.new 'JunqueNote'

puts "The main window's object ID is #{main_window.object_id}."
# END:launch


# START:typing
edit = JTextAreaOperator.new main_window #<callout id="co.jtextarea"/>
edit.type_text "this is some text"       #<callout id="co.type_text"/>
# END:typing


# START:exit
menu = JMenuBarOperator.new main_window
menu.push_menu_no_block 'File|Exit', '|'
# END:exit


# START:dialog
dialog = JDialogOperator.new "Quittin' time"
button = JButtonOperator.new dialog, "No"
button.push
# END:dialog
