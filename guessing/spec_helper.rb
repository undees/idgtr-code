# START:random_helper
require 'rubygems'
require 'hpricot'
require 'open-uri'

module RandomHelper
  def random_paragraph
    doc = Hpricot open('http://www.lipsum.com/feed/html?amount=1')
    (doc/"div#lipsum p").inner_html.strip #<callout id="co.xpath"/>
  end
end
# END:random_helper

describe 'a new document', :shared => true do
  before do
    @note = Note.open
  end
  
  after do
    @note.exit! if @note.running?
  end
end

describe 'a saved document', :shared => true do
  before do
    Note.fixture 'SavedNote'
  end
end

describe 'a reopened document', :shared => true do  
  before do
    @note = Note.open 'SavedNote'
  end
  
  after do
    @note.exit! if @note.running?
  end
end  

# START:random_find
describe 'a searchable document', :shared => true do
  include RandomHelper #<callout id="co.include_random"/>

  before do
    @example = random_paragraph #<callout id="co.use_random"/>       
    
    words = @example.split /[^A-Za-z]+/
    last_cap = words.select {|w| w =~ /^[A-Z]/}.last
    @term = last_cap[0..1] #<callout id="co.last_cap"/>

    @first_match = @example.index(/#{@term}/i)
    @second_match = @first_match ?
      @example.index(/#{@term}/i, @first_match + 1) :
      nil
    @reverse_match = @example.rindex(/#{@term}/i)
    @word_match = @example.index(/#{@term}\b/i)
    @case_match = @example.index(/#{@term}/)    

    @note.text = @example
  end
end
# END:random_find