Given /^the data source is the list \"(\[.*\])\"$/ do |source_list|
  @source_data = eval(source_list)
end


Given /^the Grab program is "([^"]*)"$/ do |program|
  @grab_program = program
end


When /^I run the Grab program on that data source$/ do
  @answer = GrabAnswer.new(@grab_program)
end


Then /^I should receive the list \"(\[.*\])\"$/ do |result|
  @answer.grab(@source_data).should == eval(result)
end
