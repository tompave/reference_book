require 'test_helper'

class BookTest < Minitest::Test

  BOOK_STRUCT = ReferenceBook::Book.new("Example", :foo, :bar)

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
  end


  def test_getters
    assert_respond_to @book, :foo
    assert_respond_to @book, :bar
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
end
