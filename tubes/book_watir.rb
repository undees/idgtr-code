# START:book_search
require 'rubygems'
require 'watir'

class BookSearch
  def initialize
    @browser = Watir::IE.new
  end

  def close
    @browser.close
  end
end
# END:book_search


# START:find
class BookSearch
  def find(term)
    @browser.goto 'http://www.pragprog.com'
    @browser.text_field(:id, 'q').set('Ruby') #<callout id="co.watir_text_field"/>
    @browser.button(:class, 'go').click       #<callout id="co.watir_button"/>

    bookshelf = @browser.table(:id, 'bookshelf')
    num_results = bookshelf.row_count

    (0...num_results).inject({}) do |results, i|
      book = bookshelf[i][1] #<callout id="co.watir_table_index"/>

      full_title = book.h4.text
      byline     = book.p(:class, 'by-line').text
      url        = book.link.href

      title, subtitle = full_title.split ': '
      authors = authors_from byline

      results.merge title => {
        :title => title,
        :subtitle => subtitle,
        :url => url,
        :authors => authors }
    end
  end
end
# END:find


class BookSearch
  def authors_from(byline)
    byline[3..-1].gsub(/(,? and )|(,? with )/, ',').split(',')
  end
end
