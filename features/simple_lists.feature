Feature: Simple lists
  In order to select items from an Enumerable collection of alternatives
  As a modeler
  I want a Grab program to include syntax that returns an explicit subset from the data source

Scenario: peek to copy an element from a list
  Given the data source is the list "[2,4,6,8,10]"
  And the Grab program is "copy 2"
  When I run the Grab program on that data source
  Then I should receive the list "[6]"


