require 'java'
require 'jemmy.jar'
require 'junquenote_app'

java_import 'org.netbeans.jemmy.JemmyProperties'
java_import 'org.netbeans.jemmy.TestOut'

%w(Frame TextArea MenuBar Dialog Button).each do |o|
  java_import "org.netbeans.jemmy.operators.J#{o}Operator"
end

JemmyProperties.set_current_timeout 'DialogWaiter.WaitDialogTimeout', 3000
JemmyProperties.set_current_output TestOut.get_null_output

JunqueNoteApp.new
main_window = JFrameOperator.new 'JunqueNote'
menu = JMenuBarOperator.new main_window

# START:bundle
java_import 'org.netbeans.jemmy.Bundle'

bundle = Bundle.new
bundle.load_from_file 'english.txt'
exit_menu = bundle.get_resource 'junquenote.exit_menu'

menu.push_menu_no_block exit_menu
# END:bundle
