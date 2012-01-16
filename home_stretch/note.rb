class Note
  attr_reader :path

  @@app = nil
  @@titles = {}

  def self.open(*args)
    @@app.new *args
  end

  # START:save_as
  DefaultOptions = {
    :password => 'password',
    :confirmation => true
  }

  def save_as(name, with_options = {})
    options = DefaultOptions.merge with_options #<callout id="co.merge"/>

    @path = @@app.path_to(name)                 #<callout id="co.set_path"/>
    File.delete @path if File.exist? @path

    menu 'File', 'Save As...'                   #<callout id="co.save_msg"/>

    enter_filename @path                        #<callout id="co.enter_pair"/>
    assign_password options
  end
  # END:save_as


  # START:exit
  def exit!(with_options = {})
    options = DefaultOptions.merge with_options
    menu 'File', 'Exit'
    @prompted[:to_confirm_exit] = dialog(@@titles[:exit]) do |d|
      d.click(options[:save_as] ? @@titles[:yes] : @@titles[:no])
    end
    if options[:save_as]
      path = @@app.path_to options[:save_as]
      enter_filename path
      assign_password options
    end
  end
  # END:exit

  # START:change_password
  def change_password(with_options = {})
    old_options = {
      :password => with_options[:old_password]} #<callout id="co.old_options"/>

    new_options = {
      :password => with_options[:password],
      :confirmation =>
        with_options[:confirmation] ||
        with_options[:password]}                #<callout id="co.new_options"/>

    menu 'File', 'Change Password...'

    unlock_password old_options
    assign_password new_options
  end
  # END:change_password

  def about
    menu 'Help', @@titles[:about_menu]

    @prompted[:with_help_text] = dialog(@@titles[:about]) do |d|
      d.click '_OK'
    end
  end

  # START:edit_menu
  [:undo, :cut, :copy, :paste, :find_next].each do |method|
    item = method.to_s.split('_').collect {|m| m.capitalize}.join(' ')
    define_method(method) {menu 'Edit', item, :wait} #<callout id="co.wait_menu"/>
  end
  # END:edit_menu

  # START:has_prompted
  def has_prompted?(kind)
    @prompted[kind]
  end
  # END:has_prompted

private

  # START:enter_filename
  def enter_filename(path, approval = '_Save')
    dialog(@@titles[:file]) do |d|
      d.type_in path
      d.click approval
    end
  end
  # END:enter_filename

  # START:unlock_password
  def unlock_password(with_options = {})
    options = DefaultOptions.merge with_options
    options[:confirmation] = false #<callout id="co.no_confirm"/>

    enter_password options
    watch_for_error
  end
  # END:unlock_password

  # START:assign_password
  def assign_password(with_options = {})
    options = DefaultOptions.merge with_options

    enter_password options
    watch_for_error

    if @prompted[:with_error]
      enter_password :cancel_password => true #<callout id="co.cancel_pw"/>
    end
  end
  # END:assign_password
end


# START:fixture
require 'fileutils'

class Note
  def self.fixture(name)
    source = @@app.path_to(name + 'Fixture')
    target = @@app.path_to(name)

    FileUtils.rm target if File.exist? target
    FileUtils.copy source, target
  end
end
# END:fixture
