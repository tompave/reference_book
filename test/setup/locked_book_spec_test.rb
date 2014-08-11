require 'test_helper'

class LockedBookSpecTest < Minitest::Test

  
  def test_constructor
    result = ReferenceBook::Setup::LockedBookSpec.new([:one])
    assert result
    assert_equal ReferenceBook::Setup::LockedBookSpec, result.class

    assert_raises ReferenceBook::LockedBookSpecError do
      ReferenceBook::Setup::LockedBookSpec.new([])
    end

    assert_raises ArgumentError do
      ReferenceBook::Setup::LockedBookSpec.new
    end
  end



  def test_verify_keys_pass
    spec = make_locked_spec

    assert spec.verify_keys!([:foo, :bar, :baz])
    assert spec.verify_keys!([:bar, :baz, :foo])
  end



  def test_verify_keys_fail_missing
    spec = make_locked_spec

    error_1 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([:foo, :bar])
    end

    reported_missing = extract_missing_keys(error_1.message)
    assert_equal reported_missing.sort, %w(baz)

    error_2 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([])
    end

    reported_missing = extract_missing_keys(error_2.message)
    assert_equal reported_missing.sort, %w(bar baz foo)
  end



  def test_verify_keys_fail_unexpected
    spec = make_locked_spec

    error_1 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([:foo, :bar, :baz, :hello])
    end

    reported_unexpected = extract_unexpected_keys(error_1.message)
    assert_equal reported_unexpected.sort, %w(hello)

    error_2 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([:foo, :baz, :one, :two, :bar])
    end

    reported_unexpected = extract_unexpected_keys(error_2.message)
    assert_equal reported_unexpected.sort, %w(one two)
  end



  def test_verify_keys_fail_missing_and_unexpected
    spec = make_locked_spec

    error_1 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([:bar, :hello, :foo])
    end

    reported_missing = extract_missing_keys(error_1.message)
    assert_equal reported_missing.sort, %w(baz)

    reported_unexpected = extract_unexpected_keys(error_1.message)
    assert_equal reported_unexpected.sort, %w(hello)

    error_2 = assert_raises ReferenceBook::BookDefinitionError do
      spec.verify_keys!([:one, :two, :three])
    end

    reported_missing = extract_missing_keys(error_2.message)
    assert_equal reported_missing.sort, %w(bar baz foo)

    reported_unexpected = extract_unexpected_keys(error_2.message)
    assert_equal reported_unexpected.sort, %w(one three two)
  end


private
  
  def make_locked_spec(keys = nil)
    keys ||= [:foo, :bar, :baz]
    ReferenceBook::Setup::LockedBookSpec.new(keys)
  end


  def extract_missing_keys(msg)
    reg = /missing keys\: \[([a-zA-Z_\-\, ]+)\]/
    data = reg.match msg
    data[1].split(', ')
  end


  def extract_unexpected_keys(msg)
    reg = /unexpected keys\: \[([a-zA-Z_\-\, ]+)\]/
    data = reg.match msg
    data[1].split(', ')
  end

end
