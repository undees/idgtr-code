module AppleScript
  class Command
    def initialize
      @lines = []
      @tells = 0
    end

    # START:method_missing
    def method_missing(name, *args, &block)
      immediate = name.to_s.include? '!'
      param = args.shift

      script = name.to_s.chomp('!').gsub('_', ' ')
      script += %Q( #{param.inspect}) if param
      
      unless immediate
        script = 'tell ' + script
        @tells += 1
      end
      
      @lines << script
      
      if block_given?
        @has_block = true
        instance_eval &block
        go!
      elsif immediate && !@has_block
        go!
      else
        self
      end
    end
    # END:method_missing
  
    def go!
      clauses = @lines.map do |line|
        '-e "' + line.gsub('"', '\"') + '"'
      end.join(' ') + ' '
      
      clauses += '-e "end tell" ' * @tells
      
      `osascript #{clauses}`
    end
  end

  def tell
    Command.new
  end
end

# include AppleScript
# 
# script.application("TextEdit").activate!
# 
# script.
#   application("System Events").
#   process("TextEdit") do
#     'Hello, there!'.split(//).each {|c| keystroke! c}
#   end
#   
# script.
#   application('System Events').
#   process('TextEdit').
#   menu_bar(1).
#   menu_bar_item('Edit').
#   menu('Edit').
#   click_menu_item!(0)
# 
# result = script.
#   application("System Events").
#   process("TextEdit").
#   window("Untitled").
#   scroll_area(1).
#   text_area(1).
#   get_value!
# 
# puts result
