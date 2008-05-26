require 'win32ole'

wsh = WIN32OLE.new 'Wscript.Shell'

wsh.Exec 'notepad'
sleep 1
wsh.AppActivate 'Untitled - Notepad'

wsh.SendKeys 'This is some text'

wsh.SendKeys '%EA'
wsh.SendKeys 'And this is its replacement'
wsh.SendKeys '%{F4}'

if wsh.AppActivate 'Notepad'
  wsh.SendKeys 'n'
end
