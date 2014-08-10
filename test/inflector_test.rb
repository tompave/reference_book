require 'test_helper'

class InflectorTest < Minitest::Test

  def test_constantize_simple_symbol
    result = ReferenceBook::Inflector.constantize :hello
    assert_equal "Hello", result
  end


  def test_constantize_two_words
    result = ReferenceBook::Inflector.constantize 'hello world'
    assert_equal "Helloworld", result
  end


  def test_constantize_already_ok
    result = ReferenceBook::Inflector.constantize 'HelloWorld'
    assert_equal "HelloWorld", result
  end


  def test_constantize_other_chars
    result = ReferenceBook::Inflector.constantize "hello-world!"
    assert_equal "Helloworld", result
  end


  def test_constantize_nil
    result = ReferenceBook::Inflector.constantize nil
    assert_equal nil, result
  end


  def test_constantize_empty
    result = ReferenceBook::Inflector.constantize ''
    assert_equal nil, result
  end


  def test_make_key_simple
    result = ReferenceBook::Inflector.make_key "hello"
    assert_equal :hello, result
  end


  def test_make_key_two_words
    result = ReferenceBook::Inflector.make_key "hello world"
    assert_equal :hello_world, result
  end


  def test_make_key_camel
    result = ReferenceBook::Inflector.make_key "HelloWorldDear"
    assert_equal :hello_world_dear, result
  end


  def test_make_key_symbol
    result = ReferenceBook::Inflector.make_key :hello
    assert_equal :hello, result
  end


  def test_make_key_upcase
    result = ReferenceBook::Inflector.make_key "heLLO"
    assert_equal :he_llo, result
  end


  def test_make_key_with_numbers
    result = ReferenceBook::Inflector.make_key "hello123_world"
    assert_equal :hello123_world, result
  end


  def test_make_key_nil
    result = ReferenceBook::Inflector.make_key nil
    assert_equal nil, result
  end
end
