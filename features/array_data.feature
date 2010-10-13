Feature: Handling items from Array data sources
  In order to select items from a data source that's an Array object
  As a modeler
  I want a Grab program to include syntax that returns an explicit subset

Scenario: 'row' command says 'copy an element from a list'
  Given the data source is the Array "[2,4,6,8,10]"
  And the Grab program is "row 2"
  When I run the Grab program on that data source
  Then I should receive the Array "[6]"


Scenario: multiple 'row' commands copy multiple elements from a list
  Given the data source is the Array "[2,4,6,8,10]"
  And the Grab program is "row 2\nrow 3"
  When I run the Grab program on that data source
  Then I should receive the Array "[6,8]"


Scenario: identical 'row' commands return multiple copies of one item in a list
  Given the data source is the Array "[1,2,3,4,5]"
  And the Grab program is "row 1\nrow 1\nrow 2"
  When I run the Grab program on that data source
  Then I should receive the Array "[2,2,3]"


Scenario: grabbing from an empty Array gives an empty answer
  Given the data source is the Array "[]"
  And the Grab program is "row 1\nrow 1\nrow -1221"
  When I run the Grab program on that data source
  Then I should receive the Array "[]"
