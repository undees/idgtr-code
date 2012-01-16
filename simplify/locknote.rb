# START:locknote
require 'windows_gui'
require 'note'
class LockNote < Note
  include WindowsGui

  # START:note_app
  @@app = LockNote
  @@titles[:save] = 'Steganos LockNote'
  # END:note_app
  
  def initialize
    system 'start "" "C:/LockNote/LockNote.exe"'

    @main_window = Window.top_level 'LockNote - Steganos LockNote'
    @edit_window = @main_window.child 'ATL:00434310'
  end
end
# END:locknote

# START:text
class LockNote
  def text
    @edit_window.text
  end
  
  def text=(message)
    keystroke VK_CONTROL, ?A
    keystroke VK_BACK
    type_in(message)
  end
  
  def close
    @main_window.close
  end
end
# END:text
