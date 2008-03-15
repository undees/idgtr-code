require 'rubygems'
require 'safariwatir'

Watir::Browser = Watir::Safari
browser = Watir::Browser.new
browser.goto 'http://www.google.com'
browser.text_field(:name, 'q').set('rspec')
browser.button(:name, 'btnG').click
