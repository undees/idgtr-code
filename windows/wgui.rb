require 'win32/guitest'
require 'win32/guitest_svn' #<callout id="co.guitest_svn"/>

include Win32::GuiTest

system 'start "" "C:/Windows/System32/notepad.exe"'
sleep 1

w = findWindowLike(nil, /^Untitled - Notepad$/).first
w.sendkeys 'This is some text'
w.sendkeys ctrl('a')
w.sendkeys 'And this is its replacement'

e = w.children.find {|c| c.classname == 'Edit'}
puts e.windowText #<callout id="co.guitest_text"/>

w.sendkeys alt(key('F4'))
sleep 0.5

d = findWindowLike(nil, /^Notepad$/).first
d.sendkeys 'n'
