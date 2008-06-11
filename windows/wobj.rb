require 'wet-winobj'
require 'winobjects/WinLabel'
require 'winobjects/WinCheckbox'
require 'winobjects/WinRadio'

include Wet::WinUtils
include Wet::Winobjects

system 'start "" "C:/Windows/System32/notepad.exe"'
sleep 1

w = app_window 'title' => 'Untitled - Notepad'

e = w.child_objects.first
e.set 'This is some text'
e.set 'And this is its replacement'
puts e.text
