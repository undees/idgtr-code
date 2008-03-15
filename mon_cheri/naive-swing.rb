include Java

import javax.swing.JFrame

include_class javax.swing.JOptionPane

frame = JFrame.new 'JRuby'

# START:button
class MyButtonListener
  include java.awt.event.ActionListener
  
  def actionPerformed(event)
    JOptionPane.showMessageDialog(
      nil,
      "You clicked me")
  end
end  

button = javax.swing.JButton.new("OK")
button.addActionListener(MyButtonListener.new)
# END:button


frame.getContentPane.add(button)

frame.pack
frame.visible = true
