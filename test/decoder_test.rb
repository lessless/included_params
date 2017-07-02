require 'test_helper'
require 'decoder'

class TestDecoder < Test::Unit::TestCase
  # Tests for #model_includes
  def test_model_includes_when_params_nil
    assert Decoder.decode(nil) == []
  end

  def test_model_includes_one_single_level_resource
    assert Decoder.decode(['foo']) == [:foo]
  end

  def test_model_includes_multiple_single_level_resources
    assert Decoder.decode(['foo', 'bar']) == [:foo, :bar]
  end

  def test_model_includes_single_two_level_resource
    assert  Decoder.decode(['foo.bar']) == [{:foo => [:bar]}]
  end

  def test_model_includes_multiple_two_level_resources
    assert Decoder.decode(['foo.bar','foo.bat']) == [{:foo => [:bar, :bat]}]
    assert  Decoder.decode(['foo.bar', 'baz.bat']) == [{:foo => [:bar]}, {:baz => [:bat]}]
  end

  def test_model_includes_three_level_resources
    assert Decoder.decode(['foo.bar.baz']) == [{:foo => [{:bar => [:baz]}]}]
  end

  def test_model_includes_multiple_three_level_resources
    assert Decoder.decode(['foo.bar.baz', 'foo', 'foo.bar.bat', 'bar']) == [{:foo => [{:bar => [:baz, :bat]}]}, :bar]
  end
end
