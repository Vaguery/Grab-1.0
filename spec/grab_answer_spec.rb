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
      my_answer = GrabAnswer.new("copy 1")
      my_answer.should_receive(:copy).with([],1)
      my_answer.grab
    end
    
    it "should execute all the lines in the blueprint" do
      my_answer = GrabAnswer.new("copy 1\ncopy 2")
      my_answer.should_receive(:copy).exactly(2).times
      my_answer.grab
    end
    
  end
  
  
  describe "copy instruction" do
    it "should copy that item number from the data if it's within the range" do
      GrabAnswer.new("foo").copy([2,3,4,5,6,7], 4).should == 6
      GrabAnswer.new("bar").copy([2,3,4,5,6,7], 0).should == 2
      
    end
    
    it "should take the item modulo the length of the data if it's outside the range" do
      GrabAnswer.new("").copy([2,3,4,5,6,7], -4).should == 4
      GrabAnswer.new("").copy([2,3,4,5,6,7], -15).should == 5
      GrabAnswer.new("").copy([2,3,4,5,6,7], 10).should == 6
      
    end
  end
end