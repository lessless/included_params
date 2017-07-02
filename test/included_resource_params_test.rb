require 'test_helper'
require 'included_resource_params'

class TestIncludedResourceParams < Test::Unit::TestCase
  # Tests for #has_included_resources?
  def test_has_included_resources_is_false_when_nil
    r = IncludedResourceParams.new(nil)
    assert r.has_included_resources? == false
  end

  def test_has_included_resources_is_false_when_only_wildcards
    include_string = 'foo.**'
    r = IncludedResourceParams.new(include_string)
    assert r.has_included_resources? == false
  end

  def test_has_included_resources_is_true_with_non_wildcard_params
    include_string = 'foo'
    r = IncludedResourceParams.new(include_string)
    assert r.has_included_resources?
  end

  def test_has_included_resources_is_true_with_both_wildcard_and_non_params
    include_string = 'foo,bar.**'
    r = IncludedResourceParams.new(include_string)
    assert r.has_included_resources?
  end

  # Tests for #included_resources
  def test_included_resources_always_returns_array
    r = IncludedResourceParams.new(nil)
    assert r.included_resources == []
  end

  def test_included_resources_returns_only_non_wildcards
    r = IncludedResourceParams.new('foo,foo.bar,baz.*,bat.**')
    assert r.included_resources == ['foo', 'foo.bar']
  end

    # Tests for #model_includes
  def test_model_includes_when_params_nil
    assert IncludedResourceParams.new(nil).model_includes == []
  end

  def test_model_includes_one_single_level_resource
    assert IncludedResourceParams.new('foo').model_includes == [:foo]
  end

  def test_model_includes_multiple_single_level_resources
    assert IncludedResourceParams.new('foo,bar').model_includes == [:foo, :bar]
  end

  def test_model_includes_single_two_level_resource
    assert IncludedResourceParams.new('foo.bar').model_includes == [{:foo => [:bar]}]
  end

  def test_model_includes_multiple_two_level_resources
    assert IncludedResourceParams.new('foo.bar,foo.bat').model_includes == [{:foo => [:bar, :bat]}]
    assert IncludedResourceParams.new('foo.bar,baz.bat').model_includes == [{:foo => [:bar]}, {:baz => [:bat]}]
  end

  def test_model_includes_three_level_resources
    assert IncludedResourceParams.new('foo.bar.baz').model_includes == [{:foo => [{:bar => [:baz]}]}]
  end

  def test_model_includes_multiple_three_level_resources
    assert IncludedResourceParams.new('foo.bar.baz,foo,foo.bar.bat,bar').model_includes == [{:foo => [{:bar => [:baz, :bat]}]}, :bar]
  end
end
