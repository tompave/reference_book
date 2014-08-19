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
    end_to_end_setup("TestPluck")

    result = ReferenceBook.library.pluck(:foo)
    assert_instance_of Array, result
    assert_equal 3, result.size
    assert_equal [11, 111, 1111], result

    assert_equal result, ReferenceBook.library.array_for(:foo)

    result = ReferenceBook.library.pluck(:baz)
    assert_instance_of Array, result
    assert_equal 3, result.size
    assert_equal [nil, 333, nil], result

    assert_equal result, ReferenceBook.library.array_for(:baz)
  end




  def test_hash_pluck
    end_to_end_setup("TestHashPluck")

    result = ReferenceBook.library.hash_pluck(:foo)
    assert_instance_of Hash, result
    assert_equal 3, result.size
    assert_equal 11, result[:aaa]
    assert_equal 111, result[:bbb]
    assert_equal 1111, result[:ccc]

    assert_equal result, ReferenceBook.library.hash_for(:foo)

    result = ReferenceBook.library.hash_pluck(:baz)
    assert_instance_of Hash, result
    assert_equal 3, result.size
    assert_nil result[:aaa]
    assert_equal 333, result[:bbb]
    assert_nil result[:ccc]

    assert_equal result, ReferenceBook.library.hash_for(:baz)
  end



  def test_to_h_no_meta
    end_to_end_setup("TestTohNoMeta")

    result = ReferenceBook.library.to_h

    assert_instance_of Hash, result
    assert_equal 3, result.size

    assert_equal({foo: 11, bar: 22, baz: nil},     result[:aaa])
    assert_equal({foo: 111, bar: 222, baz: 333},   result[:bbb])
    assert_equal({foo: 1111, bar: 2222, baz: nil}, result[:ccc])
  end


  def test_to_h_with_meta
    end_to_end_setup("TestToH")

    result = ReferenceBook.library.to_h(true)

    assert_instance_of Hash, result
    assert_equal 3, result.size

    assert_equal({foo: 11, bar: 22, baz: nil, title: "TestToHA", library_key: :aaa},     result[:aaa])
    assert_equal({foo: 111, bar: 222, baz: 333, title: "TestToHB", library_key: :bbb},   result[:bbb])
    assert_equal({foo: 1111, bar: 2222, baz: nil, title: "TestToHC", library_key: :ccc}, result[:ccc])
  end



  def test_rotate_no_meta
    end_to_end_setup("TestRotateNoMeta")

    result = ReferenceBook.library.rotate

    assert_instance_of Hash, result
    assert_equal 3, result.size

    assert_equal({aaa: 11, bbb: 111, ccc: 1111}, result[:foo])
    assert_equal({aaa: 22, bbb: 222, ccc: 2222}, result[:bar])
    assert_equal({aaa: nil, bbb: 333, ccc: nil}, result[:baz])
  end


  def test_rotate_with_meta
    end_to_end_setup("TestRotate")

    result = ReferenceBook.library.rotate(true)

    assert_instance_of Hash, result
    assert_equal 5, result.size

    assert_equal({aaa: 11, bbb: 111, ccc: 1111}, result[:foo])
    assert_equal({aaa: 22, bbb: 222, ccc: 2222}, result[:bar])
    assert_equal({aaa: nil, bbb: 333, ccc: nil}, result[:baz])

    assert_equal({aaa: "TestRotateA", bbb: "TestRotateB", ccc: "TestRotateC"}, result[:title])
    assert_equal({aaa: :aaa, bbb: :bbb, ccc: :ccc}, result[:library_key])
  end



private
  
  BOOK_STRUCT = ReferenceBook::Book.new("ExampleLib", :title, :library_key)

  def make_book(key)
    book = BOOK_STRUCT.new
    book.title = "#{key}_title"
    book.library_key = key
    book
  end



  def end_to_end_setup(base_name)
    ReferenceBook.write_book(title: "#{base_name}A", library_key: :aaa) do |b|
      b.foo = 11
      b.bar = 22
    end

    ReferenceBook.write_book(title: "#{base_name}B", library_key: :bbb) do |b|
      b.foo = 111
      b.bar = 222
      b.baz = 333
    end

    ReferenceBook.write_book(title: "#{base_name}C", library_key: :ccc) do |b|
      b.foo = 1111
      b.bar = 2222
    end
  end


end
