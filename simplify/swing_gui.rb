require 'java'
require 'jemmy.jar'

include_class 'org.netbeans.jemmy.JemmyProperties'
include_class 'org.netbeans.jemmy.TestOut'

JemmyProperties.set_current_output TestOut.get_null_output

%w(Frame TextArea MenuBar Dialog Button).each do |o|
  include_class "org.netbeans.jemmy.operators.J#{o}Operator"
end

# START:click
class JDialogOperator
  def click(title)
    b = JButtonOperator.new self, title.gsub('_', '') #<callout id="co.swing_mnemonic"/>
    b.push
  end
end
# END:click

# START:dialog
module SwingGui
  def dialog(title, seconds=3)
    JemmyProperties.set_current_timeout \
      'DialogWaiter.WaitDialogTimeout', seconds * 1000
    begin
      d = JDialogOperator.new title
      yield d #<callout id="co.yield_dialog"/>
      d.wait_closed
      true
    rescue NativeException
    end
  end
end
# END:dialog