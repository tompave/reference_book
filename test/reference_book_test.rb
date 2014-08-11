require 'test_helper'

class ReferenceBookTest < Minitest::Test


  def teardown
    super
    ReferenceBook::Library.empty!
    ReferenceBook.instance_eval { @locked_book_spec = nil }
  end



  def test_define_book_structure
    assert_nil ReferenceBook.locked_book_spec
    spec = ReferenceBook.define_book_structure :one, :two

    assert spec.is_a?(ReferenceBook::Setup::LockedBookSpec) 
    assert_equal spec, ReferenceBook.locked_book_spec
  end


  def test_define_book_structure_fail
    assert_nil ReferenceBook.locked_book_spec

    assert_raises ReferenceBook::LockedBookSpecError do
      ReferenceBook.define_book_structure
    end
  end





  def test_write_book_normal
    assert_empty ReferenceBook::Library.index
    assert_empty ReferenceBook::Library.shelf
    refute_respond_to ReferenceBook::Library, :ref_book

    book = ReferenceBook.write_book(title: "RefBook") do |b|
      b.foo = 111
      b.bar = 222
    end

    assert book.is_a?(ReferenceBook::Book)
    assert_equal "ReferenceBook::Book::RefBook", book.class.name
    assert book.frozen?
    assert_equal "RefBook", book.title
    assert_equal :ref_book, book.library_key

    assert_equal 111, book.foo
    assert_equal 222, book.bar

    assert_equal 1, ReferenceBook::Library.index.size
    assert_equal 1, ReferenceBook::Library.shelf.size

    assert_includes ReferenceBook::Library.index, :ref_book
    assert_respond_to ReferenceBook::Library, :ref_book
    assert_equal book, ReferenceBook::Library.ref_book

    assert_equal book, ReferenceBook::Library.shelf[:ref_book]
  end

  


  def test_write_more_than_one_book
    assert_empty ReferenceBook::Library.index
    assert_empty ReferenceBook::Library.shelf

    ReferenceBook.write_book(title: "RefBookA") do |b|
      b.foo = 111
      b.bar = 222
    end

    assert_equal 1, ReferenceBook::Library.index.size
    assert_equal 1, ReferenceBook::Library.shelf.size

    ReferenceBook.write_book(title: "RefBookB") do |b|
      b.foo = 111
      b.bar = 222
    end

    assert_equal 2, ReferenceBook::Library.index.size
    assert_equal 2, ReferenceBook::Library.shelf.size
  end





  def test_attributes_of_created_book
    book = ReferenceBook.write_book(title: "RefBookC") do |b|
      b.foo = 111
      b.bar = 222
      b.baz = 333
    end

    assert_equal 111, book.foo
    assert_equal 222, book.bar
    assert_equal 333, book.baz
  end




  def test_write_book_duplicated_key
    book = ReferenceBook.write_book(title: "Hello", library_key: :existing) do |b|
      b.foo = 'hello'
    end

    assert book.is_a?(ReferenceBook::Book)
    assert_equal 1, ReferenceBook::Library.index.size

    assert_raises ReferenceBook::BookDefinitionError do
      ReferenceBook.write_book(title: "HelloA", library_key: :existing) do |b|
        b.foo = 'hello'
      end
    end


    book = ReferenceBook.write_book(title: "HelloB", library_key: :another) do |b|
      b.foo = 'hello'
    end

    assert book.is_a?(ReferenceBook::Book)
    assert_equal 2, ReferenceBook::Library.index.size
  end



  def test_create_book_with_spec_pass
    ReferenceBook.define_book_structure :one, :two, :three

    book = ReferenceBook.write_book(title: "aaaa") do |b|
      b.one = 1
      b.two = 2
      b.three = 3
    end

    assert book.is_a?(ReferenceBook::Book)
    assert_equal 1, ReferenceBook::Library.index.size
  end



  def test_create_book_with_spec_fail_missing
    ReferenceBook.define_book_structure :one, :two, :three

    assert_raises ReferenceBook::BookDefinitionError do
      ReferenceBook.write_book(title: "bbbb") do |b|
        b.one = 1
        b.two = 2
      end
    end
  end


  def test_create_book_with_spec_fail_unexpected
    ReferenceBook.define_book_structure :one, :two, :three

    assert_raises ReferenceBook::BookDefinitionError do
      ReferenceBook.write_book(title: "cccc") do |b|
        b.one = 1
        b.two = 2
        b.three = 3
        b.four = 4
      end
    end
  end


  def test_create_book_with_spec_fail_missing_and_unexpected
    ReferenceBook.define_book_structure :one, :two, :three

    assert_raises ReferenceBook::BookDefinitionError do
      ReferenceBook.write_book(title: "dddd") do |b|
        b.one = 1
        b.four = 4
      end
    end
  end




  def test_library
    assert_equal ReferenceBook::Library, ReferenceBook.library
  end



  def test_locked_book_spec
    assert_respond_to ReferenceBook, :locked_book_spec
  end

end
