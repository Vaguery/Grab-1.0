Feature: Attach to a data source
  In order to extract data from a particular source with a grab program
  As a user who has data in a particular place
  I want to be able to attach a GrabExecutable to a particular data source
  
  
  Scenario: bind to an Array source
    Given the data source is the Array "['a','b','c']"
    And the Grab program is "row 2"
    When I bind the Grab program to that data source
    And I run the Grab executable
    Then the result should be the Array "['c']"