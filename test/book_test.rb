require 'test_helper'

class BookTest < Minitest::Test

  BOOK_STRUCT = ReferenceBook::Book.new("Example", :foo, :bar, :title, :library_key)

  def setup
    super
    @book = BOOK_STRUCT.new
  end


  def test_name
    assert_equal "ReferenceBook::Book::Example", @book.class.name
  end


  def test_setters
    assert_respond_to @book, :foo=
    assert_respond_to @book, :bar=
    refute_respond_to @book, :baz=
  end


  def test_getters
    assert_respond_to @book, :foo
    assert_respond_to @book, :bar
    refute_respond_to @book, :baz
  end



  def test_set_with_method
    @book.foo = 1234
    assert_equal 1234, @book.foo
  end


  def test_set_with_hash_access
    @book[:foo] = 1234
    assert_equal 1234, @book.foo
  end



  def test_get_with_method
    @book.foo = 9876
    assert_equal 9876, @book.foo
  end


  def test_get_with_hash_access
    @book.foo = 9876
    assert_equal 9876, @book[:foo]
  end


  def test_creation
    template = ReferenceBook::Book.new("Foobar", :foo, :bar, :title, :library_key)
    assert_equal Class, template.class
    assert_equal "ReferenceBook::Book::Foobar", template.name

    book = template.new
    assert book.is_a?(ReferenceBook::Book)
    assert_equal "ReferenceBook::Book::Foobar", book.class.name

    refute_equal book, @book
    assert_equal book, template.new
  end



  def test_to_h
    assert_equal Hash, @book.to_h.class
    assert_equal 4, @book.to_h.size
    assert_includes @book.to_h.keys, :foo
    assert_includes @book.to_h.keys, :bar
    assert_includes @book.to_h.keys, :title
    assert_includes @book.to_h.keys, :library_key
    
    assert_nil @book.to_h[:foo]
    assert_nil @book.to_h[:bar]

    @book.foo = 11
    @book.bar = 22
    assert_equal 11, @book.to_h[:foo]
    assert_equal 22, @book.to_h[:bar]
  end



  def test_freeze_methods
    assert_respond_to @book, :freeze
    assert_respond_to @book, :frozen?
  end


  def test_freeze_effects
    refute @book.frozen?
    @book.freeze
    assert @book.frozen?
  end


  def test_fronzen_book_attributes
    assert_nil @book.foo
    @book.foo = 1
    assert_equal 1, @book.foo
    @book.freeze
    assert_equal 1, @book.foo

    assert_raises RuntimeError do
      @book.foo = 2
    end

    assert_raises RuntimeError do
      @book.bar = 3
    end
  end



  def test_fetch_existing_key
    @book.foo = 1

    assert_equal 1, @book.fetch(:foo)
    assert_equal 1, @book.fetch(:foo, 'fallback')
  end


  def test_fetch_non_existing_key
    @book.foo = 1

    assert_raises KeyError do
      @book.fetch(:not_present)
    end

    assert_equal 'fallback', @book.fetch(:not_present, 'fallback')
  end

end
