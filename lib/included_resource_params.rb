require 'parser'
require 'decoder'

class IncludedResourceParams
  def initialize(include_param)
    @include_param = include_param
  end

  def has_included_resources?
   !included_resources.empty?
  end

  def included_resources
    @included_resources ||= Parser.parse(@include_param)
  end

  def model_includes
    Decoder.decode(included_resources)
  end
end
