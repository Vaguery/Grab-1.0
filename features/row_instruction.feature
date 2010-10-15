Feature: 'row' instruction
  In order to select individual items from a data source
  As a modeler
  I want a Grab program have an instruction to include one row (or item) of data


Scenario: 'row' command says 'copy an element from a list'
  Given the Grab program is " 2"
  And the data source is the Array "[2,4,6,8,10]" 
  And I have bound the Grab executable to that data source 
  When I run the Grab executable
  Then the result should be the Array "[6]"


Scenario: multiple 'row' commands copy multiple elements from a list
  Given the Grab program is " 2\n 3"
  And the data source is the Array "[2,4,6,8,10]"
  And I have bound the Grab executable to that data source
  When I run the Grab executable
  Then the result should be the Array "[6,8]"


Scenario: identical 'row' commands return multiple copies of one item in a list
  Given the Grab program is " 1\n 1\n 2"
  And the data source is the Array "[1,2,3,4,5]"
  And I have bound the Grab executable to that data source
  When I run the Grab executable
  Then the result should be the Array "[2,2,3]"


Scenario: grabbing from an empty Array gives an empty answer
  Given the Grab program is " 1\n 1\n -1221"
  And the data source is the Array "[]"
  And I have bound the Grab executable to that data source
  When I run the Grab executable
  Then the result should be the Array "[]"


Scenario: grabbing from a tree only produces samples from the root Array
  Given the Grab program is " 2"
  And the data source is the Array "[[1,2], [3,4], [5, [6]]]"
  And I have bound the Grab executable to that data source
  When I run the Grab executable
  Then the result should be the Array "[[5, [6]]]"


Scenario: grabbing 'row any' samples a row randomly
  Given the data source is the Array "[1,2,3,4,5,6,7,8,9,'a']"
  And the Grab program is "any"
  When I run the Grab program on that data source 10000 times
  Then there should be at least 800 of every row sampled