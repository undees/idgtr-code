# START:method_missing
module AppleScript
  class Command
    def initialize #<callout id="co.apple_init"/>
      @lines = []
      @tells = 0
    end

    def method_missing(name, *args, &block)
      immediate = name.to_s.include? '!' #<callout id="co.apple_preprocess"/>
      param = args.shift
      script = name.to_s.chomp('!').gsub('_', ' ')
      script += %Q( #{param.inspect}) if param
      
      unless immediate #<callout id="co.apple_immediate"/>
        script = 'tell ' + script
        @tells += 1
      end
      
      @lines << script
      
      if block_given? #<callout id="co.apple_decide"/>
        @has_block = true
        instance_eval &block
        go!
      elsif immediate && !@has_block
        go!
      else
        self
      end
    end
  end
end
# END:method_missing


# START:go
module AppleScript
  class Command
    def go!
      clauses = @lines.map do |line|
        '-e "' + line.gsub('"', '\"') + '"'
      end.join(' ') + ' '
      
      clauses += '-e "end tell" ' * @tells
      
      `osascript #{clauses}`.chomp("\n")
    end
  end
end
# END:go


# START:tell
module AppleScript
  def tell
    Command.new
  end
end
# END:tell
