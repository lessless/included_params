class Decoder

  # Service facade
  class << self
    def decode(resources)
      new.decode(resources)
    end
  end

  def decode(resources)
    return [] if resources.nil?

    singular, nested = resources.partition { |resource| singular?(resource) }
    decoded = nested.reduce([]) { |memo, resource| merge(memo, decode_resource(resource)) }

    singular.delete_if do |singular_resource|
      decoded.any? { |nested_resource| nested_resource.keys.first == singular_resource.to_sym }
    end

    decoded | singular.map(&:to_sym)
  end

  def decode_resource(resource)
    if singular?(resource)
      resource.to_sym
    else
      decode_array(resource)
    end
  end

  def singular?(resource)
    !resource.include?(separator)
  end

  def separator
    '.'
  end

  def decode_array(resource)
    resources = resource.split(separator())
    do_decode_array([], resources, resources.first.to_sym)
  end

  def do_decode_array(memo, resources, parent)
    return memo if resources.empty?

    if resources.length == 1
      merge(memo, [resources.first.to_sym])
    else
      next_root = resources.shift.to_sym
      [{next_root => do_decode_array(memo, resources, next_root.to_sym)}]
    end
  end

  def merge(dst, candidate)
    case candidate
      when Symbol
        dst << candidate
      when Hash
        candidate_root = candidate.keys.first
        candidate_index = dst.index { |resource| resource.keys.first == candidate_root }

        if candidate_index.nil?
          dst << candidate
        else
          if candidate[candidate_root].is_a?(Array)
            merge(dst[candidate_index][candidate_root], candidate[candidate_root].first)
          else
            dst[candidate_index][candidate_root] = dst[candidate_index][candidate_root] | candidate[candidate_root]
          end
        end

        dst
      when Array
        merge(dst, candidate.first)
    end
  end
end
