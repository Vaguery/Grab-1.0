require 'strscan'


class GrabExecutable
  
  @@recognized_lines = Regexp.union(/row\s+(\d+)/,/row\s+any/, /^all/)
  
  attr_reader :blueprint, :result
  attr_accessor :data_source
  
  
  def initialize(blueprint, data_source=nil)
    @blueprint = blueprint
    @data_source = data_source unless data_source.nil?
  end
  
  
  def attach_to_source(data_source)
    @data_source = data_source
    return
  end
  
  
  def grab(data=@data_source)
    return [] if data.nil?
    
    raise ArgumentError unless data.kind_of?(Array)
    
    result = []
    @blueprint.each_line do |line|
      case line.strip
      when /^all/
        result += all(data)
      when /row\s+(\d+)/
        which_element = $1.to_i
        result += [row(data, which_element)]
      when /row\s+any/
        result += [data.sample]
      else
      end
    end
    
    return result.reject {|i| i.nil?}
  end
  
  
  def run
    @result = grab(@data_source)
  end
  
  
  def row(data, which)
    return data.length > 0 ? data[which % data.length] : nil
  end
  
  
  def all(data)
    return data
  end
  
  
  
  def points
    valid_lines = (@blueprint.lines.reject {|l| l.strip.empty?}).
      find_all {|l| l.match(@@recognized_lines)}
    valid_lines.to_a.length
  end
end
