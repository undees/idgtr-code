require 'locknote'

EditControl = LockNote::EditControl

Note.open.instance_eval do
  menu 'Edit', 'Select All'
  type_in 'asggzwhcbgk'
  keystroke 17, 90; sleep 0.5
  @main_window.click EditControl, :left, [370, 253]
  @main_window.click EditControl, :left, [370, 253]
  @main_window.click EditControl, :left, [644, 255]
  # ...
end
