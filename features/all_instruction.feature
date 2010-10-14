Feature: 'all' instruction
  In order to start from a comprehensive base of samples
  As a modeler
  I want a Grab program to include an instruction to get all row from the data source


Scenario: 'all' command says 'one copy of every element'
  Given the Grab program is "all"
  And the data source is the Array "[2,4,6,8,10]" 
  And I have bound the Grab executable to that data source 
  When I run the Grab executable
  Then the result should be the Array "[2,4,6,8,10]"


Scenario: multiple 'all' instructions work as expected
  Given the Grab program is "all \nall"
  And the data source is the Array "[2,4]" 
  And I have bound the Grab executable to that data source 
  When I run the Grab executable
  Then the result should be the Array "[2,4,2,4]"
