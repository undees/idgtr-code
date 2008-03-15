require 'windows_gui'
require 'note'


class LockNote < Note
  include WindowsGui

  @@app = LockNote
  @@titles =
  {
    :file => 'Save As',
    :exit  => 'Steganos LockNote',
    :about => 'About Steganos LockNote...',
    :about_menu  => 'About',
    :dialog => 'Steganos LockNote'
  }
  
  # START:atlres
  BasePath = "C:\\LockNote"
  WindowsGui.load_symbols "#{BasePath}\\src\\resource.h"
  WindowsGui.load_symbols "#{BasePath}\\src\\atlres.h"
  ID_HELP_ABOUT = ID_APP_ABOUT
  # END:atlres
      
  # START:initialize
  def initialize(name = nil, with_options = {})
    options = DefaultOptions.merge(with_options)
    
    @prompted = {}
    @path = LockNote.path_to(name || 'LockNote')
    
    system 'start "" "' + @path + '"'
    unlock_password options
    
    if @prompted[:with_error] || options[:cancel_password]
      @main_window = 0
      sleep 1.0
    else
      @main_window = Window.top_level "#{name} - Steganos LockNote"
      @edit_window = @main_window.child "ATL:00434310"

      set_foreground_window @main_window.handle
    end
  end
  # END:initialize
  
  def select_all
    keystroke VK_CONTROL, ?A
  end
  
  def text
    @edit_window.text
  end
  
  # START:set_text
  def text=(new_text)
    select_all
    keystroke VK_BACK
    type_in new_text
  end
  # END:set_text

  # START:selection
  def selection
    result = send_message @edit_window.handle, EM_GETSEL, 0, 0
    bounds = [result].pack('L').unpack('SS')
    bounds[0]...bounds[1] #<callout id="co.range"/>
  end
  # END:selection
  
  # START:go_to
  def go_to(where)
    case where
      when :beginning
        keystroke VK_CONTROL, VK_HOME
      when :end
        keystroke VK_CONTROL, VK_END
    end
  end
  # END:go_to
  
  # START:find_dialog
  WholeWord = 0x0410
  ExactCase = 0x0411
  SearchUp  = 0x0420
  
  def find(term, with_options={})
    menu 'Edit', 'Find...'

    appeared = dialog('Find') do |d|
      type_in term
      
      d.click WholeWord if with_options[:whole_word]
      d.click ExactCase if with_options[:exact_case]
      d.click SearchUp if :back == with_options[:direction]
      
      d.click IDOK
      d.click IDCANCEL
    end
    
    raise 'Find dialog did not appear' unless appeared
  end
  # END:find_dialog
  
  # START:running_p
  def running?
    @main_window != 0 && is_window(@main_window.handle) != 0
  end
  # END:running_p
  
  # START:win_menu
  def menu(name, item, wait = false)
    multiple_words = /[.]/
    single_word = /[ .]/
    
    [multiple_words, single_word].each do |pattern|
      words = item.gsub(pattern, '').split
      const_name = ['ID', name, *words].join('_').upcase
      msg = WM_COMMAND
      
      begin
        id = LockNote.const_get const_name
        action = wait ? :send_message : :post_message
        
        return send(action, @main_window.handle, msg, id, 0)
      rescue NameError
      end
    end
  end
  # END:win_menu

  def self.path_to(name)
    "#{BasePath}\\#{name}.exe"
  end  

private

  # START:enter_password
  def enter_password(with_options = {})
    options = DefaultOptions.merge with_options

    @prompted[:for_password] = dialog(@@titles[:dialog]) do |d|
      type_in options[:password]

      confirmation =
        options[:confirmation] == true ?
        options[:password] :
        options[:confirmation]    
      
      if confirmation
        keystroke VK_TAB
        type_in confirmation
      end
          
      d.click options[:cancel_password] ? IDCANCEL : IDOK
    end
  end
  # END:enter_password
  
  # START:watch_for_error
  ErrorIcon = 0x0014
  
  def watch_for_error
    if @prompted[:for_password]
      @prompted[:with_error] = dialog(@@titles[:dialog]) do |d|
        d.click IDCANCEL if get_dlg_item(d.handle, ErrorIcon) > 0 #<callout id="co.nil"/>
      end
    end
  end
  # END:watch_for_error
end
