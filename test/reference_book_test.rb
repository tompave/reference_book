require 'test_helper'

class ReferenceBookTest < Minitest::Test

  # def setup
  #   super
  #   ReferenceBook::Library.empty!
  # end


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
  end




  def test_attributes_of_created_book
  end



  def test_create_book_without_title
  end

  
  def test_create_book_without_explicit_key
  end



  def test_write_book_duplicated_key

  end



  def test_create_book_with_spec_pass
  end



  def test_create_book_with_spec_fail_missing
  end


  def test_create_book_with_spec_fail_unexpected
  end


  def test_create_book_with_spec_fail_missing_and_unexpected
  end


  

  def test_library
    assert_equal ReferenceBook::Library, ReferenceBook.library
  end



  def test_locked_book_spec
    assert_respond_to ReferenceBook, :locked_book_spec
  end

end
