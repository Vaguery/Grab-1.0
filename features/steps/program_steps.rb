Given /^the data source is the Array \"(\[.*\])\"$/ do |source_list|
  @source_data = eval(source_list)
end


Given /^the Grab program is "([^"]*)"$/ do |program|
  program.gsub!('\n',"\n")
  program.gsub!('\t',"\t")
  @grab_program = program
end


When /^I run the Grab program on that data source$/ do
  @result = GrabExecutable.new(@grab_program).grab(@source_data)
end


When /^I run the Grab program on that data source (\d+) times$/ do |how_many|
  how_many = how_many.to_i
  @many_results = how_many.times.collect {GrabExecutable.new(@grab_program).grab(@source_data)}
end


Then /^I should receive the Array \"(\[.*\])\"$/ do |result|
  @result == eval(result)
end


Then /^there should be at least (\d+) of every row sampled$/ do |min_number|
  histogram = @many_results.inject(Hash.new(0)) { |hash, item| hash[item[0]] += 1; hash}
  @source_data.each {|i| histogram[i].should > min_number.to_i}
end


Then /^the number of points in the Grab program should be (\d+)$/ do |pts|
  GrabExecutable.new(@grab_program).points.should == pts.to_i
end