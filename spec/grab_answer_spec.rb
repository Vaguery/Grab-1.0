require 'spec_helper'

describe "GrabAnswer class" do
  describe "initialization" do
    it "should accept a string blueprint" do
      GrabAnswer.new("foo bar").blueprint.should == "foo bar"
    end
  end
  
  describe "#grab" do
    it "should raise an error if the data source isn't an Enumerable" do
      lambda { GrabAnswer.new("foo bar").grab("baz") }.should raise_error ArgumentError
    end
    
    it "should return an empty result Array if the data source isn't there" do
      GrabAnswer.new("foo bar").grab.should == []
    end
    
    it "should execute the blueprint's first line" do
      data = [1,2]
      my_answer = GrabAnswer.new("row 3")
      my_answer.should_receive(:row).with([1,2],3).and_return(99)
      my_answer.grab(data)
    end
    
    it "should execute all the lines in the blueprint" do
      my_answer = GrabAnswer.new("row 1\nrow 2")
      my_answer.should_receive(:row).exactly(2).times
      my_answer.grab
    end
    
    it "should return the set of all results of those lines" do
      my_answer = GrabAnswer.new("row 1\nrow 2")
      my_answer.grab([1,2,3]).length.should == 2
      my_answer.grab([1,2,3]).should == [2,3]
    end
  end
  
  
  describe "row instruction" do
    it "should copy that item number from the data if it's within the range" do
      GrabAnswer.new("foo").row([2,3,4,5,6,7], 4).should == 6
      GrabAnswer.new("bar").row([2,3,4,5,6,7], 0).should == 2
    end
    
    it "should take the item modulo the length of the data if it's outside the range" do
      GrabAnswer.new("").row([2,3,4,5,6,7], -4).should == 4
      GrabAnswer.new("").row([2,3,4,5,6,7], -15).should == 5
      GrabAnswer.new("").row([2,3,4,5,6,7], 10).should == 6
    end
    
    it "should return a nil answer if the data is an empty set" do
       GrabAnswer.new("").row([], -4).should == nil
    end
  end
end