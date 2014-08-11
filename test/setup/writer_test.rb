require 'test_helper'

class WriterTest < Minitest::Test

  def test_initialize_with_locked_spec
    assert ReferenceBook::Setup::Writer.new(make_locked_spec)
  end


  def test_initialize_with_nil
    assert ReferenceBook::Setup::Writer.new(nil)
    assert ReferenceBook::Setup::Writer.new
  end


  def test_create_book_normal
    writer = ReferenceBook::Setup::Writer.new
    collector = make_collector

    book = writer.create_book_with('title', 'key', collector)

    assert book.is_a?(ReferenceBook::Book)
    assert_equal "ReferenceBook::Book::Title", book.class.name
    assert book.frozen?
    assert_equal "Title", book.title
    assert_equal :key, book.library_key
  end



  def test_attributes_of_created_book
    collector = make_collector one: 1, two: 2, three: '3'
    writer = ReferenceBook::Setup::Writer.new
    book = writer.create_book_with('CheckAttrs', nil, collector)

    assert_equal collector.one, book.one
    assert_equal collector.two, book.two
    assert_equal collector.three, book.three

    assert_equal "CheckAttrs", book.title
    assert_equal :check_attrs, book.library_key
  end



  def test_create_book_without_title
    writer = ReferenceBook::Setup::Writer.new
    collector = make_collector

    book = writer.create_book_with(nil, nil, collector)

    assert book.is_a?(ReferenceBook::Book)
    assert_equal "ReferenceBook::Book::Default", book.class.name
    assert book.frozen?
    assert_equal "Default", book.title
    assert_equal :default, book.library_key
  end



  def test_create_book_without_explicit_key
    writer = ReferenceBook::Setup::Writer.new
    collector = make_collector

    book = writer.create_book_with('MyTitle', nil, collector)

    assert book.is_a?(ReferenceBook::Book)
    assert book.frozen?
    assert_equal "MyTitle", book.title
    assert_equal :my_title, book.library_key
  end



  def test_create_book_with_symbol_key_parameter
    writer = ReferenceBook::Setup::Writer.new
    collector = make_collector

    book = writer.create_book_with('titlea', :"Not Nice", collector)

    assert book.is_a?(ReferenceBook::Book)
    assert book.frozen?
    assert_equal "Titlea", book.title
    assert_equal :"Not Nice", book.library_key
  end




  def test_create_book_with_duplicated_library_key
    writer = ReferenceBook::Setup::Writer.new
    collector = make_collector
    
    book = writer.create_book_with('TitleOne', :existing_key, collector)
    ReferenceBook::Library.store(book)

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('TitleTwo', :existing_key, collector)
    end

    book = writer.create_book_with('TitleThree', :new_key, collector)
    assert book.is_a?(ReferenceBook::Book)

    ReferenceBook::Library.empty!
  end



  def test_create_book_with_spec_pass
    spec = make_locked_spec [:one, :two, :three]
    writer = ReferenceBook::Setup::Writer.new(spec)
    collector = make_collector one: 1, two: 2, three: 3

    book = writer.create_book_with('with spec pass', nil, collector)

    assert book.is_a?(ReferenceBook::Book)
    assert_equal "ReferenceBook::Book::Withspecpass", book.class.name
    assert book.frozen?
    assert_equal "Withspecpass", book.title
    assert_equal :with_spec_pass, book.library_key
  end



  def test_create_book_with_spec_fail_missing
    spec = make_locked_spec [:one, :two, :three]
    writer = ReferenceBook::Setup::Writer.new(spec)
    collector = make_collector one: 1, two: 2

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('with spec fail', nil, collector)
    end

    empty_collector = ReferenceBook::Setup::Collector.new

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('with spec fail', nil, empty_collector)
    end
  end


  def test_create_book_with_spec_fail_unexpected
    spec = make_locked_spec [:one, :two, :three]
    writer = ReferenceBook::Setup::Writer.new(spec)
    collector = make_collector one: 1, two: 2, three: 3, four: 4

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('with spec fail', nil, collector)
    end


    collector = make_collector foo: 1, bar: 2

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('with spec fail', nil, collector)
    end
  end


  def test_create_book_with_spec_fail_missing_and_unexpected
    spec = make_locked_spec [:one, :two, :three]
    writer = ReferenceBook::Setup::Writer.new(spec)
    collector = make_collector one: 1, two: 2, four: 4

    assert_raises ReferenceBook::BookDefinitionError do
      writer.create_book_with('with spec fail', nil, collector)
    end
  end



private
  
  def make_collector(keys = {})
    collector = ReferenceBook::Setup::Collector.new
    if keys.any?
      keys.each_pair { |k, v| collector[k] = v }
    else
      collector.foo = 11
      collector.bar = 22
      collector.baz = 33
    end
    collector
  end


  def make_locked_spec(keys = nil)
    keys ||= [:foo, :bar, :baz]
    ReferenceBook::Setup::LockedBookSpec.new(keys)
  end



  def debug(book)
    puts <<-EOS

    ----
    book: #{book}
    ----
    EOS
  end
end
