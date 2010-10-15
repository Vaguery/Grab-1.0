require 'spec_helper'

describe "GrabAdapter" do
  describe "initialize" do
    it "should accept and store a data_source as an arg" do
      GrabAdapter.new([1,2,3]).data_source.should == [1,2,3]
    end
    
    it "should infer the data_source_type is :array if it is one" do
      GrabAdapter.new([1,2,3]).data_source_type.should == :array
    end
    
    it "should infer the data_source_type is :array_of_hashes if it is one" do
      GrabAdapter.new([{a:1},{b:2}]).data_source_type.should == :array_of_hashes
    end
    
    it "should infer the data_source_type is a csv if it ends in '.csv'" do
      GrabAdapter.new("something.csv").data_source_type.should == :csv
    end
    
    it "should default data_source_type to :unknown" do
      GrabAdapter.new("foo bar").data_source_type.should == :unknown
    end
  end
end



describe "#length" do
  it "should return 0 for empty connection" do
    GrabAdapter.new(nil).length.should == 0
  end
  
  it "should return the array length for an :array connection" do
    GrabAdapter.new([1,2,3,4]).length.should == 4
  end
  
  it "should return the array length for an :array_of_hashes connection" do
    GrabAdapter.new([{a:1},{b:2}]).length.should == 2
  end
end


describe "row instruction" do
  it "should copy that item number from the data if it's within the range" do
    GrabAdapter.new([2,3,4,5,6,7]).row(4).should == 6
    GrabAdapter.new([2,3,4,5,6,7]).row(0).should == 2
  end
  
  it "should take the item modulo the length of the data if it's outside the range" do
    GrabAdapter.new([2,3,4,5,6,7]).row(-4).should == 4
    GrabAdapter.new([2,3,4,5,6,7]).row(-15).should == 5
    GrabAdapter.new([2,3,4,5,6,7]).row(10).should == 6
  end
  
  it "should return a nil answer if the data is an empty set" do
     GrabAdapter.new([]).row(-4).should == nil
  end
  
  describe "[row] any" do
    it "should sample one element of the data at random" do
      [1,2,3].should include GrabExecutable.new("any").grab([1,2,3])[0]
    end
  end
end


describe "all instruction" do
  it "should return an Array containing every row of the data_connection" do
    GrabAdapter.new([2,3,4,5,6,7]).all.should == [2,3,4,5,6,7]
  end
  
  it "should return an empty Array for an empty connection" do
    GrabAdapter.new([]).all.should == []
  end
end



describe "headers" do
  it "should return an Array" do
    GrabAdapter.new("anything").headers.should be_a_kind_of(Array)
  end
  
  it "should always include :grab_index" do
    GrabAdapter.new("all").headers.should include(:grab_index)
  end
  
  it "should include :column_1 if the data_source_type is :array" do
    GrabAdapter.new([1,2,3]).headers.should == [:grab_index, :column_1]
  end
  
  it "should include all the keys in all rows if the data_source_type is :array_of_hashes" do
    GrabAdapter.new([{foo:1}, {bar:2, baz:3}]).headers.should == [:grab_index, :foo, :bar, :baz]
  end
end
