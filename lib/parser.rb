class Parser

  # Service facade
  class << self
    def parse(params)
      new.parse(params)
    end
  end

  def parse(params)
    return [] if params.nil?

    params.split(separator()).reduce([]) do |memo, param|
      is_specific_resource?(param) ? (memo << param) : memo
    end
  end

  def separator()
    ','
  end

  def is_specific_resource?(param)
    !param.include?('*')
  end
end
