require 'spec_helper'

describe "GrabExecutable class" do
  describe "initialization" do
    it "should accept a string script" do
      GrabExecutable.new("foo bar").script.should == "foo bar"
    end
    
    it "should accept an optional data_source argument" do
      GrabExecutable.new("foo bar").data_connection.should == nil
    end
  end
  
  
  describe "points" do
    it "should return the number of lines for simple grab programs" do
      GrabExecutable.new("1\n2").points.should == 2
    end
    
    it "should skip blank lines" do
      GrabExecutable.new("\n\n\n2").points.should == 1
    end
    
    it "should skip garbage lines" do
      GrabExecutable.new("hhhhhh\n2").points.should == 1
    end
    
  end
  
  describe "#grab" do
    it "should accept a GrabAdapter as a data_source argument" do
      lambda { GrabExecutable.new("foo bar").grab(GrabAdapter.new([1,2])) }.should_not raise_error
    end
      
    it "should wrap an argument that isn't a GrabAdapter already in a new one" do
      GrabAdapter.should_receive(:new).with(["foo", "bar"])
      GrabExecutable.new("foo bar").grab(["foo", "bar"])
    end
    
    it "should return an empty result Array if no data_source is given" do
      GrabExecutable.new("foo bar").grab.should == []
    end
    
    it "should return an empty result Array if data_source is nil" do
      GrabExecutable.new("foo bar").grab(nil).should == []
    end
    
    it "shouldn't gripe if the data_source is some weird thing" do
      GrabExecutable.new("foo bar").grab(Object).should == []
    end
    
    it "should default to a stored data_source, if there is one" do
      my_answer = GrabExecutable.new("1")
      my_answer.attach_to_source([1,2,3])
      my_answer.grab.should == [2]
    end
    
    it "should execute the script's first line" do
      data = [1,2]
      my_answer = GrabExecutable.new("3", data)
      my_answer.data_connection.should_receive(:row).with(3).exactly(1).times.and_return(99)
      my_answer.grab
    end
    
    it "should execute all the lines in the script" do
      my_answer = GrabExecutable.new("1\n2", [1,2])
      my_answer.data_connection.should_receive(:row).exactly(2).times.and_return([1,2])
      my_answer.grab
    end
    
    it "should return the set of all results of those lines" do
      my_answer = GrabExecutable.new("1 \n 2")
      my_answer.grab([1,2,3]).length.should == 2
      my_answer.grab([1,2,3]).should == [2,3]
      
      my_answer = GrabExecutable.new("all \nall")
      my_answer.grab([1,2,3]).should == [1,2,3,1,2,3]
      
    end
    
    it "should never return nils" do
      my_answer = GrabExecutable.new("1\n2")
      my_answer.grab([nil, nil]).length.should == 0
      my_answer.grab([nil, nil]).should == []
    end
  end
  
  
  describe "parsing lines" do
    before(:each) do
      @data = [2,3,4,5,6,7]
    end
    it "should ignore empty lines" do
      GrabExecutable.new("2\n\n3").grab(@data).should == [4,5]
    end
    
    it "should ignore central whitespace in a line" do
      GrabExecutable.new("   \t  2").grab(@data).should == [4]
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee").grab(@data).should == []
    end
    
    it "should ignore garbage lines" do
      GrabExecutable.new("fiddledeedee \n  2").grab(@data).should == [4]
    end
    
    it "should recognize 'row' instructions" do
      GrabExecutable.new("").grab(@data).should == []
      GrabExecutable.new("2").grab(@data).should_not == []
    end
    
    it "should recognize 'any' instructions" do
      GrabExecutable.new("any").grab(@data).should_not == []
    end
    
    it "should recognize 'all' instructions" do
      GrabExecutable.new("all").grab(@data).should == [2,3,4,5,6,7]
    end
    
    it "should ignore garbage following a recognized instruction on a line" do
      GrabExecutable.new("all foo").grab(@data).should == [2,3,4,5,6,7]
      GrabExecutable.new("1 bar").grab(@data).should == [3]
      GrabExecutable.new("any baz").grab(@data).length.should == 1
    end
    
    it "should ignore following instructions on one line" do
      GrabExecutable.new("2 all").grab(@data).should == [4]
    end
  end
  
  
  describe "run" do
    it "should execute :grab and record the result in @result" do
      grabby = GrabExecutable.new("1",[1,2,3])
      grabby.run
      grabby.result.should == [2]
    end
    
    it "should produce an empty array if no data is provided or bound in" do
      grabby = GrabExecutable.new("1")
      grabby.run.should == []
    end
  end
  
  
  describe "#attach_to_source" do
    it "should accept an Array" do
      lambda { GrabExecutable.new("foo").attach_to_source([1,2,3]) }.should_not raise_error
    end
  end
  
  describe "not row \d" do
    it "should remove all copies of that particular item from the intermediate result" do
      GrabExecutable.new("all\nnot 2", [2,3,4,4,5,6,7]).run.should == [2, 3, 5, 6, 7]
      GrabExecutable.new("all\nnot -1", [2,3,4,5,6,7,7,7]).run.should == [2, 3, 4, 5, 6]
      GrabExecutable.new("all\nnot 15", [2,3,4,5,6,7,2,2]).run.should == [3, 4, 5, 6, 7]
    end
  end
  
  
  describe "not row any" do
    it "should remove all copies of a random item from the intermediate result" do
      GrabExecutable.new("all\nnot any", [2,2,2,2,2,2]).run.should == []
      GrabExecutable.new("all\nnot any", [2,2,2,3,3,3]).run.length.should == 3
    end
  end
  
  describe "not all" do
    it "should remove everything in the dataset from the intermediate result" do
      GrabExecutable.new("all\nnot all", [1,2,3,4,5]).run.should == []
    end
  end
end
