require 'applescript'

include AppleScript

tell.application("TextEdit").activate!

tell.application("System Events").
  process("TextEdit").
  menu_bar(1).
  menu_bar_item("Edit").
  menu("Edit") do
    keystroke! "H"
    keystroke! "i"
    click_menu_item! "Select All"
    click_menu_item! "Copy"
		key_code! 124
		click_menu_item! "Paste"
  end
  
  # app('System Events').
  #   processes['TextEdit'].
  #   menu_bars[1].
  #   menu_bar_items['Edit'].
  #   menus['Edit'].
  #   menu_items['Select All'].click
