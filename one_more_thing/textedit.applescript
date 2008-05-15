-- START:activate
tell application "TextEdit"
  activate
end tell
-- END:activate

tell application "System Events"
  tell process "TextEdit"
    keystroke "h"
    keystroke "e"
    keystroke "l"
    keystroke "l"
    keystroke "o"
  end tell
end tell

-- START:menu_bar
tell application "System Events"
  tell process "TextEdit"
    tell menu bar 1
      tell menu bar item "Edit"
        tell menu "Edit"
          click menu item "Select All"
          click menu item "Copy"
		  key code 124
		  click menu item "Paste"
        end tell
      end tell
    end tell
  end tell
end tell
-- END:menu_bar
