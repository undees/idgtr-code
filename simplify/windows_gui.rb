# START:snake_case
class String
  def snake_case
    gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase #<callout id="snake_regex"/>
  end
end
# END:snake_case


# START:def_api
require 'Win32API'

module WindowsGui
  def self.def_api(function, parameters, return_value)              #<callout id="co.def_api"/>
    api = Win32API.new 'user32', function, parameters, return_value

    define_method(function.snake_case) do |*args|                   #<callout id="co.define_method"/>
      api.call *args                                                #<callout id="co.expand"/>
    end
  end
end
# END:def_api


# START:first_cut
module WindowsGui
  def_api 'FindWindow',    ['P', 'P'], 'L'
  def_api 'keybd_event',   ['I', 'I', 'L', 'L'], 'V'

  # rest of API definitions here...

  WM_GETTEXT = 0x000D
  WM_SYSCOMMAND = 0x0112

  # rest of constant definitions here...
end
# END:first_cut


module WindowsGui
  def_api 'FindWindow',      ['P', 'P'], 'L'
  def_api 'FindWindowEx',    ['L', 'L', 'P', 'P'], 'L'
  def_api 'PostMessage',     ['L', 'L', 'L', 'L'], 'L'
  def_api 'SendMessage',     ['L', 'L', 'L', 'P'], 'L'
  def_api 'keybd_event',     ['I', 'I', 'L', 'L'], 'V'
  def_api 'GetDlgItem',      ['L', 'L'], 'L'
  def_api 'GetWindowRect',   ['L', 'P'], 'I'
  def_api 'SetCursorPos',    ['L', 'L'], 'I'
  def_api 'mouse_event',     ['L', 'L', 'L', 'L', 'L'], 'V'
  def_api 'IsWindowVisible', ['L'], 'L'

  SC_CLOSE = 0xF060

  IDNO = 7

  MOUSEEVENTF_LEFTDOWN = 0x0002
  MOUSEEVENTF_LEFTUP = 0x0004

  KEYEVENTF_KEYDOWN = 0
  KEYEVENTF_KEYUP = 2
end


# START:modifiers
module WindowsGui
  VK_SHIFT   = 0x10
  VK_CONTROL = 0x11
  VK_BACK    = 0x08
end
# END:modifiers


# START:to_keys
class String
  def to_keys
    unless size == 1                 #<callout id="co.size"/>
      raise "conversion is for single characters only"
    end

    ascii = unpack('C')[0]           #<callout id="co.ascii"/>

    case self                        #<callout id="co.keycodes"/>
    when '0'..'9'
      [ascii - ?0 + 0x30]
    when 'A'..'Z'
      [WindowsGui.const_get(:VK_SHIFT), ascii]
    when 'a'..'z'
      [ascii - ?a + ?A]
    when ' '
      [ascii]
    else
      raise "Can't convert unknown character #{self}"
    end
  end
end
# END:to_keys


# START:keystroke
module WindowsGui
  def keystroke(*keys)
    return if keys.empty?

    keybd_event keys.first, 0, KEYEVENTF_KEYDOWN, 0
    sleep 0.05
    keystroke *keys[1..-1]
    sleep 0.05
    keybd_event keys.first, 0, KEYEVENTF_KEYUP, 0
  end
end
# END:keystroke


# START:type_in
module WindowsGui
  def type_in(message)
    message.scan(/./m) do |char|
      keystroke(*char.to_keys)
    end
  end
end
# END:type_in


# START:window
module WindowsGui
  class Window
    include WindowsGui #<callout id="co.nested"/>

    attr_reader :handle

    def initialize(handle)
      @handle = handle
    end

    def close
      post_message @handle, WM_SYSCOMMAND, SC_CLOSE, 0
    end

    def wait_for_close #<callout id="co.wait_for_close"/>
      timeout(5) do
        sleep 0.2 until 0 == is_window_visible(@handle)
      end
    end

    def text
      buffer = '\0' * 2048
      length = send_message @handle, WM_GETTEXT, buffer.length, buffer
      length == 0 ? '' : buffer[0..length - 1]
    end
  end
end
# END:window


# START:top_level
class WindowsGui::Window
  extend WindowsGui #<callout id="co.include_self"/>

  def self.top_level(title, seconds=3)
    @handle = timeout(seconds) do
      sleep 0.2 while (h = find_window nil, title) <= 0; h
    end

    Window.new @handle
  end
end
# END:top_level


# START:child_handle
class WindowsGui::Window
  def child(id)
    result = case id
    when String
      by_title = find_window_ex @handle, 0, nil, id.gsub('_', '&') #<callout id="co.win_mnemonic"/>
      by_class = find_window_ex @handle, 0, id, nil
      by_title > 0 ? by_title : by_class
    when Fixnum
      get_dlg_item @handle, id
    else
      0
    end

    raise "Control '#{id}' not found" if result == 0
    Window.new result
  end
end
# END:child_handle


# START:click
class WindowsGui::Window
  def click(id)
    h = child(id).handle

    rectangle = [0, 0, 0, 0].pack 'LLLL'
    get_window_rect h, rectangle
    left, top, right, bottom = rectangle.unpack 'LLLL'

    center = [(left + right) / 2, (top + bottom) / 2]
    set_cursor_pos *center

    mouse_event MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
    mouse_event MOUSEEVENTF_LEFTUP, 0, 0, 0, 0
  end
end
# END:click


# START:dialog
module WindowsGui
  def dialog(title, seconds=3)
    d = begin
      w = Window.top_level(title, seconds)
      yield(w) ? w : nil #<callout id="co.dialog_nil"/>
    rescue TimeoutError
    end

    d.wait_for_close if d
    return d
  end
end
# END:dialog
