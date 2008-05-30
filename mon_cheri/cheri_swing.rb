require 'rubygems'
require 'cheri/swing'

include Cheri::Swing
include_class javax.swing.JOptionPane

window = swing do
  frame('JRuby') do |f|
    # START:button
    button('OK') do
      on_click do
        JOptionPane.show_message_dialog \
          nil, 'You clicked me'
      end
    end
    # END:button
  end
end

window.pack
window.show
