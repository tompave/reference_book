# To optionally define and enforce a static book structure.
# Without this, books are free-form.
#
ReferenceBook.define_book_structure :price, :currency, :country_name, :date_format


# Given the structure defined above:


# This is valid
#
ReferenceBook.write_book(title: "UnitedStates", library_key: :us) do |book|
  book.price = 12
  book.currency = '$'
  book.country_name = 'US'
  book.date_format = '%-m/%-d/%Y'
end


# This is valid too. The library_key will be ':united_kingdom'
#
ReferenceBook.write_book(title: "UnitedKingdom") do |book|
  book.price = 10
  book.currency = '£'
  book.country_name = 'UK'
  book.date_format = '%-d/%-m/%Y'
end


# This will raise an error because of the missing keys
#
ReferenceBook.write_book(title: "Canada") do |book|
  book.price = 12
end


# This will raise an error because of the unexpected key
#
ReferenceBook.write_book(title: "Italy", library_key: :italy) do |book|
  book.price = 10
  book.currency = '€'
  book.country_name = 'Italy'
  book.date_format = '%-d/%-m/%Y'
  book.international_prefix = '+39'
end
