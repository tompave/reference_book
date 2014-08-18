require 'test_helper'

class LibraryTest < Minitest::Test


  def setup
    super
    ReferenceBook::Library.empty!
  end


  def teardown
    super
    ReferenceBook::Library.empty!
  end



  def test_shelf_class
    assert_equal Hash, ReferenceBook::Library.shelf.class
  end


  def test_index_class
    assert_equal Array, ReferenceBook::Library.index.class
  end



  def test_with_no_book_stored
    assert_empty ReferenceBook::Library.index
    assert_empty ReferenceBook::Library.shelf
  end


  def test_store
    refute_respond_to ReferenceBook::Library, :one
  
    book = make_book(:one)
    result = ReferenceBook::Library.store(book)

    assert_equal book, result

    refute_empty ReferenceBook::Library.index
    assert_includes ReferenceBook::Library.index, :one
    assert_equal 1, ReferenceBook::Library.index.size

    refute_empty ReferenceBook::Library.shelf
    assert_equal book, ReferenceBook::Library.shelf[:one]
    assert_equal 1, ReferenceBook::Library.shelf.size

    assert_respond_to ReferenceBook::Library, :one
    assert_equal book, ReferenceBook::Library.one
  end



  def test_store_incremental
    assert_empty ReferenceBook::Library.index
    assert_empty ReferenceBook::Library.shelf

    book_1 = make_book(:one)
    book_2 = make_book(:two)

    ReferenceBook::Library.store book_1

    assert_equal 1, ReferenceBook::Library.index.size
    assert_includes ReferenceBook::Library.index, :one

    assert_equal 1, ReferenceBook::Library.shelf.size
    assert_equal book_1, ReferenceBook::Library.shelf[:one]

    assert_respond_to ReferenceBook::Library, :one
    assert_equal book_1, ReferenceBook::Library.one


    ReferenceBook::Library.store book_2

    assert_equal 2, ReferenceBook::Library.index.size
    assert_includes ReferenceBook::Library.index, :one
    assert_includes ReferenceBook::Library.index, :two

    assert_equal 2, ReferenceBook::Library.shelf.size
    assert_equal book_1, ReferenceBook::Library.shelf[:one]
    assert_equal book_2, ReferenceBook::Library.shelf[:two]

    assert_respond_to ReferenceBook::Library, :one
    assert_equal book_1, ReferenceBook::Library.one
    assert_respond_to ReferenceBook::Library, :two
    assert_equal book_2, ReferenceBook::Library.two
  end



  def test_empty
    book = make_book(:one)
    ReferenceBook::Library.store(book)

    assert_includes ReferenceBook::Library.index, :one
    assert_equal book, ReferenceBook::Library.shelf[:one]
    assert_respond_to ReferenceBook::Library, :one

    ReferenceBook::Library.empty!

    assert_empty ReferenceBook::Library.index
    assert_empty ReferenceBook::Library.shelf
    refute_respond_to ReferenceBook::Library, :one
  end




  def test_hash_access
    assert_nil ReferenceBook::Library[:one]
    assert_nil ReferenceBook::Library[:two]

    book = make_book(:one)
    result = ReferenceBook::Library.store(book)

    assert_equal book, ReferenceBook::Library[:one]
    assert_nil ReferenceBook::Library[:two]
  end



  def test_accessor_methods
    refute_respond_to ReferenceBook::Library, :one
    refute_respond_to ReferenceBook::Library, :two

    book = make_book(:one)
    result = ReferenceBook::Library.store(book)

    assert_respond_to ReferenceBook::Library, :one
    assert_equal book, ReferenceBook::Library.one
    refute_respond_to ReferenceBook::Library, :two
  end



  def test_verify_library_key
    assert_nil ReferenceBook::Library.verify_library_key! :one
    assert_nil ReferenceBook::Library.verify_library_key! :two

    ReferenceBook::Library.store(make_book(:one))

    assert_raises ReferenceBook::BookDefinitionError do
      ReferenceBook::Library.verify_library_key! :one
    end
    assert_nil ReferenceBook::Library.verify_library_key! :two
  end




  def test_pluck
    ReferenceBook.write_book(title: "TestPluckA") do |b|
      b.foo = 11
      b.bar = 22
    end

    ReferenceBook.write_book(title: "TestPluckB") do |b|
      b.foo = 111
      b.bar = 222
      b.baz = 333
    end

    ReferenceBook.write_book(title: "TestPluckC") do |b|
      b.foo = 1111
      b.bar = 2222
    end

    result = ReferenceBook.library.pluck(:foo)
    assert_instance_of Array, result
    assert_eql 3, result.size
    assert_eql [11, 111, 1111].sort, result.sort

    result = ReferenceBook.library.pluck(:baz)
    assert_instance_of Array, result
    assert_eql 3, result.size
    assert_eql [nil, nil, 333].sort, result.sort
  end




  def test_hash_pluck
    ReferenceBook.write_book(title: "TestHashPluckA", library_key: :aaa) do |b|
      b.foo = 11
      b.bar = 22
    end

    ReferenceBook.write_book(title: "TestHashPluckB", library_key: :bbb) do |b|
      b.foo = 111
      b.bar = 222
      b.baz = 333
    end

    ReferenceBook.write_book(title: "TestHashPluckC", library_key: :ccc) do |b|
      b.foo = 1111
      b.bar = 2222
    end

    result = ReferenceBook.library.hash_pluck(:foo)
    assert_instance_of Hash, result
    assert_equal 3, result.size
    assert_nil result[:aaa]
    assert_equal 333, result[:bbb]
    assert_nil result[:ccc]
  end


private
  
  BOOK_STRUCT = ReferenceBook::Book.new("ExampleLib", :title, :library_key)

  def make_book(key)
    book = BOOK_STRUCT.new
    book.title = "#{key}_title"
    book.library_key = key
    book
  end


end
