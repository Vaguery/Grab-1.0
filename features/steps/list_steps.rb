Given /^the data source is the Array \"(\[.*\])\"$/ do |source_list|
  @source_data = eval(source_list)
end


Given /^the Grab program is "([^"]*)"$/ do |program|
  program.gsub!('\n',"\n")
  program.gsub!('\t',"\t")
  @grab_program = program
end


When /^I run the Grab program on that data source$/ do
  @answer = GrabExecutable.new(@grab_program)
end


Then /^I should receive the Array \"(\[.*\])\"$/ do |result|
  @answer.grab(@source_data).should == eval(result)
end
