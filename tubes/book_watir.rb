class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end


# BEGIN:book_search
require 'rubygems'
require 'watir'

class BookSearch
  def initialize
    @browser = Watir::IE.new
  end
  
  def shutdown
    @browser.close
  end
end
# END:book_search


# BEGIN:find  
class BookSearch
  def find(term)
    @browser.goto 'http://www.pragprog.com'
    @browser.text_field(:id, 'q').set('Ruby')
    @browser.button(:class, 'go').click
    
    bookshelf = @browser.table(:id, 'bookshelf')
    num_results = bookshelf.row_count

    (1..num_results).inject({}) do |results, i|
      book = bookshelf[i][2]

      title = book.h4(:index, 1).text
      by    = book.p(:class, 'by-line').text
      url   = book.link(:index, 1).href

      title, subtitle = title.split ': '
      authors = by.split(/by|and|,|with/).map(&:strip).reject(&:empty?)
      
      results.merge title => {
        :title => title,
        :subtitle => subtitle,
        :url => url,
        :authors => authors }
    end
  end
end
# END:find
