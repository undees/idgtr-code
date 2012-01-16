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

shared_context 'a new document' do
  before do
    @note = Note.open
  end

  after do
    @note.exit! if @note.running?
  end
end

shared_context 'a saved document' do
  before do
    Note.fixture 'SavedNote'
  end
end

shared_context 'a reopened document' do
  before do
    @note = Note.open 'SavedNote'
  end

  after do
    @note.exit! if @note.running?
  end
end

# START:random_find
shared_context 'a searchable document' do
  include RandomHelper #<callout id="co.include_random"/>

  before do
    @paragraph = random_paragraph #<callout id="co.use_random"/>

    words = @paragraph.split /[^A-Za-z]+/
    last_cap = words.select {|w| w =~ /^[A-Z]/}.last
    @term = last_cap[0..1] #<callout id="co.last_cap"/>

    @first_match = @paragraph.index(/#{@term}/i)
    @second_match = @first_match ?
      @paragraph.index(/#{@term}/i, @first_match + 1) :
      nil
    @reverse_match = @paragraph.rindex(/#{@term}/i)
    @word_match = @paragraph.index(/#{@term}\b/i)
    @case_match = @paragraph.index(/#{@term}/)

    @note.text = @paragraph
  end
end
# END:random_find
