# START:create
class Note
  @@app = nil   #<callout id="co.attribute"/>
  @@titles = {} #<callout id="co.titles"/>
    
  def self.open
    @@app.new
  end
end
# END:create


# START:exit
class Note
  def exit!
    @main_window.close
    
    @prompted = dialog(@@titles[:save]) do |d| #<callout id="co.save_title"/>
      d.click '_No'
    end
  end

  def has_prompted?
    @prompted
  end
end
# END:exit
