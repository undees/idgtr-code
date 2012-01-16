require 'applescript'

include AppleScript

RightArrow = 124

tell.application("TextEdit").activate! #<callout id="co.apple_bang"/>
tell.application("TextEdit").make_new_document!

tell.application("System Events").
  process("TextEdit").
  menu_bar(1).
  menu_bar_item("Edit"). #<callout id="co.apple_tell"/>
  menu("Edit") do  #<callout id="co.apple_block"/>
    keystroke! "H"
    keystroke! "i"
    click_menu_item! "Select All"
    click_menu_item! "Copy"
    key_code! RightArrow
       click_menu_item! "Paste"
  end
