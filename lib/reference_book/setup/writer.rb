class ReferenceBook::Setup::Writer

  
  def initialize(book_spec = nil)
    @book_spec = book_spec
  end



  def create_book_with(raw_title, raw_library_key, collector)
    values = collector.to_h
    verify_values!(values)
    
    book_title, library_key = sanitize_title_and_key(raw_title, raw_library_key)

    verify_library_key!(library_key)

    values[:title] = book_title
    values[:library_key] = library_key

    write_book_with(book_title, values)
  end


private


  def write_book_with(title, hash)
    template = define_book_struct_with(title, hash.keys)
    book = template.new
    hash.each_pair { |k, v| book[k] = v }
    book.freeze
    book
  end




  def define_book_struct_with(title, keys)
    ReferenceBook::Book.new(title, *keys)
  end



  def verify_values!(values)
    @book_spec.verify_keys!(values.keys) if @book_spec
  end


  def verify_library_key!(key)
    ReferenceBook::Library.verify_library_key!(key)
  end


  def sanitize_title_and_key(raw_title, raw_library_key)
    raw_title       ||= "Default"
    raw_library_key ||= raw_title

    book_title    = ReferenceBook::Inflector.make_title(raw_title)
    library_key   = ReferenceBook::Inflector.make_key(raw_library_key)

    [book_title, library_key]
  end

end
