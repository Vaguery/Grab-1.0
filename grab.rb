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
      when /row (\d+)/
        which_element = $1.to_i
        result << row(data, which_element)
      else
      end
    end
    
    return result
  end
  
  def row(data, which)
    return data.length > 0 ? data[which % data.length] : nil
  end
  
end