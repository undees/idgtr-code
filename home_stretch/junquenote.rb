require 'swing_gui'
require 'junquenote_app'
require 'note'

class JunqueNote < Note
  @@app = JunqueNote
  @@titles =
  {
    :file => "Input",
    :exit  => "Quittin' time",
    :about => "About JunqueNote",
    :about_menu  => "About JunqueNote...",
    :yes => "Yes",
    :no => "No"
  }

  include SwingGui

  # START:initialize
  def initialize(name = nil, with_options = {})
    options = DefaultOptions.merge(with_options)

    @prompted = {}
    @path = JunqueNote.path_to(name) if name

    @program = JunqueNoteApp.new
    @main_window = JFrameOperator.new 'JunqueNote'
    @edit_window = JTextAreaOperator.new @main_window
    @menu_bar = JMenuBarOperator.new @main_window

    if name
      menu 'File', 'Open...'
      enter_filename @path, '_Open'
      unlock_password options
    end

    if @prompted[:with_error] || options[:cancel_password]
      @program = nil
    end
  end
  # END:initialize

  def text
    @edit_window.text
  end

  # START:set_text
  def text=(message)
    @edit_window.select_all
    @edit_window.type_text message
  end
  # END:set_text

  # START:selection
  def selection
    first = @edit_window.get_selection_start
    last = @edit_window.get_selection_end
    Range.new(first, last - 1)
  end
  # END:selection

  # START:go_to
  def go_to(where)
    case where
      when :beginning
        @edit_window.set_caret_position 0
      when :end
        @edit_window.set_caret_position text.length
    end
  end
  # END:go_to

  # START:find_dialog
  def find(term, with_options={})
    command = 'Find...'
    command = 'Find Exact Case...' if with_options[:exact_case]
    command = 'Reverse ' + command if :back == with_options[:direction]

    menu 'Edit', command

    dialog('Input') do |d|
      d.type_in term
      d.click 'OK'
    end
  end
  # END:find_dialog

  # START:running_p
  def running?
    @main_window && @main_window.visible
  end
  # END:running_p

  # START:jruby_menu
  def menu(name, item, wait = false)
    action = wait ? :push_menu : :push_menu_no_block
    @menu_bar.send action,  name + '|' + item, '|'
  end
  # END:jruby_menu

  def select_all
    @edit_window.select_all
  end

  def self.path_to(name)
    name + '.junque'
  end

private

# START:enter_password
  def enter_password(with_options = {})
    options = DefaultOptions.merge with_options

    @prompted[:for_password] = single_password_entry \
      options[:password], options[:cancel_password]

    confirmation =
      options[:confirmation] == true ?
      options[:password] :
      options[:confirmation]

    if @prompted[:for_password] && confirmation
      single_password_entry confirmation, false
    end
  end

  def single_password_entry(password, cancel)
    dialog('Input') do |d|
      d.type_in password
      d.click(cancel ? 'Cancel' : 'OK')
    end
  end
  # END:enter_password

  # START:watch_for_error
  def watch_for_error
    if @prompted[:for_password]
      @prompted[:with_error] = dialog('Oops') do |d|
        d.click 'OK'
      end
    end
  end
  # END:watch_for_error
end
