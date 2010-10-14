Feature: Grab program points
  In order to examine and manipulate Grab structures while searching
  As a modeler
  I want a whole slew of program point methods

  Scenario: one-line grab programs have one point
    Given the Grab program is "row 2"
    Then the number of points in the Grab program should be 1
  
  Scenario: simple grab programs report their length as number of lines
    Given the Grab program is "row 1\nrow 2\nrow 2"
    Then the number of points in the Grab program should be 3
  
  Scenario: grab programs do not report empty lines as points
    Given the Grab program is "row 1\n\nrow 2"
    Then the number of points in the Grab program should be 2
  
  Scenario: grab programs do not report garbage lines as points
    Given the Grab program is "blah de blah\nrow 1"
    Then the number of points in the Grab program should be 1
  
  Scenario: empty grab programs have 0 points
    Given the Grab program is ""
    Then the number of points in the Grab program should be 0
