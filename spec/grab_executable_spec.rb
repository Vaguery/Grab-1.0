require 'spec_helper'

describe "GrabExecutable class" do
  describe "initialization" do
    it "should accept a string blueprint" do
      GrabExecutable.new("foo bar").blueprint.should == "foo bar"
    end
  end
  
  describe "#grab" do
    it "should accept an Array as a data source" do
      lambda { GrabExecutable.new("foo bar").grab(["foo", "bar"]) }.should_not raise_error ArgumentError
    end
    
    
    it "should raise an error if the data source isn't an Enumerable" do
      lambda { GrabExecutable.new("foo bar").grab("baz") }.should raise_error ArgumentError
    end
    
    it "should return an empty result Array if the data source isn't there" do
      GrabExecutable.new("foo bar").grab.should == []
    end
    
    it "should execute the blueprint's first line" do
      data = [1,2]
      my_answer = GrabExecutable.new("row 3")
      my_answer.should_receive(:row).with([1,2],3).and_return(99)
      my_answer.grab(data)
    end
    
    it "should execute all the lines in the blueprint" do
      my_answer = GrabExecutable.new("row 1\nrow 2")
      my_answer.should_receive(:row).exactly(2).times
      my_answer.grab
    end
    
    it "should return the set of all results of those lines" do
      my_answer = GrabExecutable.new("row 1\nrow 2")
      my_answer.grab([1,2,3]).length.should == 2
      my_answer.grab([1,2,3]).should == [2,3]
    end
    
    it "should never return nils" do
      my_answer = GrabExecutable.new("row 1\nrow 2")
      my_answer.grab([nil, nil]).length.should == 0
      my_answer.grab([nil, nil]).should == []
    end
  end
  
  
  describe "parsing lines" do
    before(:each) do
      @data = [2,3,4,5,6,7]
    end
    it "should ignore empty lines" do
      GrabExecutable.new("row 2\n\nrow 3").grab(@data).should == [4,5]
    end
    
    it "should ignore whitespace in a line" do
      GrabExecutable.new("row   \t  2").grab(@data).should == [4]
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee").grab(@data).should == []
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee \nrow 2").grab(@data).should == [4]
    end
  end
  
  
  describe "row instruction" do
    it "should copy that item number from the data if it's within the range" do
      GrabExecutable.new("foo").row([2,3,4,5,6,7], 4).should == 6
      GrabExecutable.new("bar").row([2,3,4,5,6,7], 0).should == 2
    end
    
    it "should take the item modulo the length of the data if it's outside the range" do
      GrabExecutable.new("").row([2,3,4,5,6,7], -4).should == 4
      GrabExecutable.new("").row([2,3,4,5,6,7], -15).should == 5
      GrabExecutable.new("").row([2,3,4,5,6,7], 10).should == 6
    end
    
    it "should return a nil answer if the data is an empty set" do
       GrabExecutable.new("").row([], -4).should == nil
    end
  end
  
  
  describe "garbage lines" do
  end
end