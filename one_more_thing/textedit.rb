require 'rubygems'
require 'appscript'

include Appscript

app("TextEdit").activate
app("TextEdit").make(:new => :document)

events = app("System Events")
events.keystroke "H"
events.keystroke "i"

edit = app('System Events').
  processes['TextEdit'].
  menu_bars[1].
  menu_bar_items['Edit'].
  menus['Edit']

edit.menu_items['Select All'].click
edit.menu_items['Copy'].click

RightArrow = 124
events.key_code RightArrow

edit.menu_items['Paste'].click
