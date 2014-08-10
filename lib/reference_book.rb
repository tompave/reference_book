module ReferenceBook; end

require 'reference_book/book'
require 'reference_book/errors'
require 'reference_book/inflector'
require 'reference_book/library'
require 'reference_book/setup'
require 'reference_book/setup/collector'
require 'reference_book/setup/locked_book_spec'
require 'reference_book/setup/writer'
require 'reference_book/version'


module ReferenceBook
  class << self

    attr_reader :locked_book_spec


    # to lock the structure of Books, optional
    #
    # ReferenceBook.define_book_structure :attr_1, :attr_2, 'attr_3', ...
    #
    def define_book_structure(*book_keys)
      @locked_book_spec = Setup::LockedBookSpec.new(book_keys)
    end




    # with block with 1 argument
    #
    # ReferenceBook.write_book(title: :sym_or_str) do |book|
    #   book.some_prop = "foobar"
    # end
    #
    def write_book(opts = {}, &block)
      collector = Setup::Collector.new
      yield collector

      writer = Setup::Writer.new(locked_book_spec)
      book = writer.create_book_with(opts[:title], opts[:library_key], collector)

      library.store(book)
    end






    



    def library
      ReferenceBook::Library
    end

  end

end
