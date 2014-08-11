require 'test_helper'

class CollectorTest < Minitest::Test

  def setup
    super
    @collector = ReferenceBook::Setup::Collector.new
  end



  def test_undefined_keys
    assert_nil @collector.foobar
    assert_empty @collector.to_h
  end


  def test_direct_assignement
    assert_nil @collector.foo
    assert_nil @collector.bar

    @collector.foo = "ciao"

    assert_equal "ciao", @collector.foo
    assert_nil @collector.bar
  end


  def test_hash_assignement
    assert_nil @collector.foo
    assert_nil @collector.bar

    @collector[:foo] = "ciao"

    assert_equal "ciao", @collector.foo
    assert_nil @collector.bar
  end



  def test_to_hash
    assert_empty @collector.to_h
    assert_equal Hash, @collector.to_h.class

    @collector.foo = "hello"
    @collector.bar = "ciao"

    refute_empty @collector.to_h
    assert_equal 2, @collector.to_h.size
    assert_equal "hello", @collector.to_h[:foo]
    assert_equal "ciao", @collector.to_h[:bar]
    assert_nil @collector.to_h[:baz]
  end


  def test_assign_nil
    assert_nil @collector.foo
    assert_empty @collector.to_h

    @collector.foo = nil

    assert_nil @collector.foo
    assert_equal 1, @collector.to_h.size
    assert_includes @collector.to_h.keys, :foo
  end



  def test_set_title_direct
    assert_raises ReferenceBook::BookDefinitionError do
      @collector.title = 'anything'
    end
  end


  def test_set_library_key_direct
    assert_raises ReferenceBook::BookDefinitionError do
      @collector.library_key = 'anything'
    end
  end


  def test_set_title_hash
    assert_raises ReferenceBook::BookDefinitionError do
      @collector[:title] = 'anything'
    end
  end


  def test_set_library_key_hash
    assert_raises ReferenceBook::BookDefinitionError do
      @collector[:library_key] = 'anything'
    end
  end

end
