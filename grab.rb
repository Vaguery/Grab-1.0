class GrabAnswer
  
  attr_reader :blueprint
  
  def initialize(blueprint)
    @blueprint = blueprint
  end
  
  def grab(data=[])
    raise ArgumentError unless data.kind_of?(Enumerable)
    
    result = []
    @blueprint.each_line do |line|
      case line
      when /copy (\d+)/
        result << copy(data, $1.to_i)
      end
    end
    
    return result
  end
  
  def copy(data, which)
    return data[which % data.length]
  end
  
end