class GrabExecutable
  
  attr_reader :blueprint
  @@recognized_lines = Regexp.union(/row\s+(\d+)/,/row\s+any/)
  
  def initialize(blueprint)
    @blueprint = blueprint
  end
  
  
  def grab(data=[])
    raise ArgumentError unless data.kind_of?(Array)
    
    result = []
    @blueprint.each_line do |line|
      case line
      when /row\s+(\d+)/
        which_element = $1.to_i
        result << row(data, which_element)
      when /row\s+any/
        result << data.sample
      else
      end
    end
    
    return result.reject {|i| i.nil?}
  end
  
  
  def row(data, which)
    return data.length > 0 ? data[which % data.length] : nil
  end
  
  
  def points
    valid_lines = (@blueprint.lines.reject {|l| l.strip.empty?}).
      find_all {|l| l.match(@@recognized_lines)}
    valid_lines.to_a.length
  end
end