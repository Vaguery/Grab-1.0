require 'spec_helper'

describe "GrabExecutable class" do
  describe "initialization" do
    it "should accept a string blueprint" do
      GrabExecutable.new("foo bar").blueprint.should == "foo bar"
    end
    
    it "should accept an optional data_source" do
      GrabExecutable.new("foo bar").data_source.should == nil
    end
  end
  
  
  describe "points" do
    it "should return the number of lines for simple grab programs" do
      GrabExecutable.new("row 1\nrow 2").points.should == 2
    end
    
    it "should skip blank lines" do
      GrabExecutable.new("\n\n\nrow 2").points.should == 1
    end
    
    it "should skip garbage lines" do
      GrabExecutable.new("hhhhhh\nrow 2").points.should == 1
    end
    
  end
  
  describe "#grab" do
    it "should accept an Array as a data source" do
      lambda { GrabExecutable.new("foo bar").grab(["foo", "bar"]) }.should_not raise_error ArgumentError
    end
    
    it "should raise an error if the data source isn't an Array" do
      lambda { GrabExecutable.new("foo bar").grab("baz") }.should raise_error ArgumentError
    end
    
    it "should return an empty result Array if the data source isn't there" do
      GrabExecutable.new("foo bar").grab.should == []
    end
    
    it "should default to a stored data_source, if any" do
      my_answer = GrabExecutable.new("row 1")
      my_answer.attach_to_source([1,2,3])
      my_answer.grab.should == [2]
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
      my_answer.grab([1,2])
    end
    
    it "should return the set of all results of those lines" do
      my_answer = GrabExecutable.new("row 1\nrow 2")
      my_answer.grab([1,2,3]).length.should == 2
      my_answer.grab([1,2,3]).should == [2,3]
      
      my_answer = GrabExecutable.new("all \nall")
      my_answer.grab([1,2,3]).should == [1,2,3,1,2,3]
      
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
    
    it "should ignore central whitespace in a line" do
      GrabExecutable.new("row   \t  2").grab(@data).should == [4]
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee").grab(@data).should == []
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee \nrow 2").grab(@data).should == [4]
    end
    
    it "should recognize 'row \d' instructions" do
      GrabExecutable.new("row").grab(@data).should == []
      GrabExecutable.new("row 2").grab(@data).should_not == []
    end
    
    it "should recognize 'row any' instructions" do
      GrabExecutable.new("row foo").grab(@data).should == []
      GrabExecutable.new("row any").grab(@data).should_not == []
    end
    
    it "should recognize 'all' instructions" do
      GrabExecutable.new("all").grab(@data).should == [2,3,4,5,6,7]
    end
    
    it "should ignore garbage following a recognized instruction on a line" do
      GrabExecutable.new("all foo").grab(@data).should == [2,3,4,5,6,7]
      GrabExecutable.new("row 1 bar").grab(@data).should == [3]
      GrabExecutable.new("row any baz").grab(@data).length.should == 1
    end
    
    it "should ignore following instructions on one line" do
      GrabExecutable.new("row 2 all").grab(@data).should == [4]
    end
  end
  
  
  describe "run" do
    it "should execute :grab and record the result in @result" do
      grabby = GrabExecutable.new("row 1",[1,2,3])
      grabby.run
      grabby.result.should == [2]
    end
    
    it "should produce an empty array if no data is provided or bound in" do
      grabby = GrabExecutable.new("row 1")
      grabby.run.should == []
    end
  end
  
  
  describe "#attach_to_source" do
    it "should accept an Array" do
      lambda { GrabExecutable.new("foo").attach_to_source([1,2,3]) }.should_not raise_error
    end
  end
  
  describe "all instruction" do
    it "should copy all elements of the data_source over to the working result" do
      GrabExecutable.new("foo").all([2,3,4,5,6,7]).should == [2,3,4,5,6,7]
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
    
    describe "row any" do
      it "should sample one element of the data at random" do
        [1,2,3].should include GrabExecutable.new("row any").grab([1,2,3])[0]
      end
    end
  end
  
  
  describe "not row \d" do
    it "should remove all copies of that particular item from the intermediate result" do
      GrabExecutable.new("all\nnot row 2", [2,3,4,4,5,6,7]).run.should == [2, 3, 5, 6, 7]
      GrabExecutable.new("all\nnot row -1", [2,3,4,5,6,7,7,7]).run.should == [2, 3, 4, 5, 6]
      GrabExecutable.new("all\nnot row 15", [2,3,4,5,6,7,2,2]).run.should == [3, 4, 5, 6, 7]
    end
  end
  
  
  describe "not row any" do
    it "should remove all copies of a random item from the intermediate result" do
      GrabExecutable.new("all\nnot row any", [2,2,2,2,2,2]).run.should == []
      GrabExecutable.new("all\nnot row any", [2,2,2,3,3,3]).run.length.should == 3
    end
  end
  
  describe "not all" do
    it "should remove everything in the dataset from the intermediate result" do
      GrabExecutable.new("all\nnot all", [1,2,3,4,5]).run.should == []
    end
  end
  
end
