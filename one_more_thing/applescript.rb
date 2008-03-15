module AppleScript
  class Command
    attr_reader :parent, :children, :command, :bang, :block
  
    def initialize(parent = nil, command = nil, bang = false)
      @parent = parent
      @command = command
      @bang = bang
      @block = false

      @children = []
    end
  
    # foo_bar('baz').quux! =>
    #   tell foo bar "baz"
    #     quux
    #   end tell
    #
    def method_missing(name, *args, &block)
      arg = !args.empty? && args[0].inspect
      func = name.to_s.chomp('!').gsub('_', ' ')
      has_bang = name.to_s.include? '!'
    
      @children << Command.new(self, "#{func} #{arg}", has_bang)
    
      should_run = if block_given?
        @block = true
        @children.last.instance_eval &block
        @children.last.children.detect {|c| c.bang}
      else
        has_bang && !parent.block
      end
    
      should_run ? run! : @children.last
    end
  
    def run!
      root = self
      root = root.parent while root.parent && root.parent.command

      clauses = root.to_s.collect do |line|
        '-e "' + line.strip.gsub('"', '\"') + '"'
      end.join ' '

      `osascript #{clauses}`
    end
  
    def to_s
      pre = bang ? "" : "tell "
      post = bang ? "" : "\nend tell"
    
      pre + command + children.inject("") do |s, c|
        s + "\n" + c.to_s
      end + post
    end
  end

  def script
    Command.new
  end
end

include AppleScript

script.application("TextEdit").activate!

script.
  application("System Events").
  process("TextEdit") do
    'string'.split(//).each {|c| keystroke! c}
  end
  
script.
  application('System Events').
  process('TextEdit').
  menu_bar(1).
  menu_bar_item('Edit').
  menu('Edit').
  click_menu_item!(0)
