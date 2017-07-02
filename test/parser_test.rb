require 'test_helper'
require 'parser'

class TestParser < Test::Unit::TestCase
  # Tests for #included_resources
  def test_included_resources_always_returns_array
    r = Parser.parse(nil)
    assert r == []
  end

  def test_included_resources_returns_only_non_wildcards
    r = Parser.parse('foo,foo.bar,baz.*,bat.**')
    assert r == ['foo', 'foo.bar']
  end
end
