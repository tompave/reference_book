require 'test_helper'

class LibraryTest < Minitest::Test


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



  def test_store
  end

end
