ReferenceBook.define_book_structure :price, :currency, :country_name, :date_format

# valid
ReferenceBook.write_book(title: "United States") do |book|
  book.price = 10
  book.currency = '$'
  book.country_name = 'US'
  book.date_format = '%-m/%-d/%Y'
end


# raises
ReferenceBook.write_book(title: "United Kingdom") do |book|
  book.price = 10
  book.currency = '£'
  book.country_name = 'UK'
  book.date_format = '%-d/%-m/%Y'
end


ReferenceBook.write_book(title: "Italia") do |book|
  book.price = 12
  book.currency = '€'
  book.country_name = 'Italy'
  book.date_format = '%-d/%-m/%Y'
end

