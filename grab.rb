require 'csv'


class GrabExecutable
  
  @@recognized_lines = Regexp.union(/^(-?\d+)/,/^any/, /^all/, /^not\s+(-?\d+)/)
  
  attr_reader :script, :result
  attr_accessor :data_connection
  
  
  def initialize(script, data_source=nil)
    @script = script
    @data_connection = GrabAdapter.new(data_source) unless data_source.nil?
  end
  
  
  def attach_to_source(data_source)
    @data_connection = GrabAdapter.new(data_source)
  end
  
  
  def grab(connection=@data_connection)
    return [] if connection.nil?
    connection = GrabAdapter.new(connection) unless connection.kind_of?(GrabAdapter)
    
    result = []
    @script.each_line do |line|
      case line.strip
      when /^all/
        result += connection.all
      when /^(-?\d+)/
        which_element = $1.to_i
        result << connection.row(which_element)
      when /^not\s+(-?\d+)/
        which_element = $1.to_i
        remove_this = connection.row(which_element)
        result = result.reject {|item| item == remove_this}
      when /^any/
        result << connection.sample
      when /^not\s+any/
        remove_this = connection.sample
        result = result.reject {|item| item == remove_this}
      when /^not\s+all/
        result = result.reject {|item| connection.include?(item)}
      else
      end
    end
    
    return result.reject {|i| i.nil?}
  end
  
  
  def run
    @result = grab(@data_connection)
  end
  
  
  def points
    valid_lines = (@script.lines.reject {|l| l.strip.empty?}).
      find_all {|l| l.match(@@recognized_lines)}
    valid_lines.to_a.length
  end
end


class GrabAdapter
  include Enumerable
  
  attr_reader :data_source
  attr_reader :data_source_type
  
  def initialize(data_source)
    @data_source = data_source
    
    case 
    when @data_source.kind_of?(Array)
      number_of_non_hashes = (@data_source.reject {|item| !item.kind_of?(Hash)}).length
      @data_source_type = number_of_non_hashes == 0 ? :array : :array_of_hashes
    when @data_source.kind_of?(String)
      case @data_source
      when /.csv$/
        @data_source_type = :csv
      else
        @data_source_type = :unknown
      end
    else
      @data_source_type = :unknown
    end
  end
  
  
  def each
    case @data_source_type
    when :array, :array_of_hashes
      @data_source.each {|row| yield row}
    end
  end
  
  
  def [](index)
    case @data_source_type
    when :array, :array_of_hashes
      @data_source[index]
    end
  end
  
  
  def length
    @length ||= case @data_source_type
    when :array, :array_of_hashes
      @data_source.length
    else
      0
    end
  end
  
  
  def row(which)
    if self.length > 0 
      index = which % self.length
      self[index]
    else
      nil
    end
  end
  
  
  def all
    @data_source.collect {|i| i}
  end
  
  
  def sample
    @data_source[rand(self.length)]
  end
  
  
  def headers
    result = [:grab_index]
    if [:array, :array_of_hashes].include? @data_source_type
      if @data_source[0].respond_to?(:keys)
        @data_source.each {|item| result |= item.keys}
      else
        result << :column_1
      end
    end
    return result
  end
end