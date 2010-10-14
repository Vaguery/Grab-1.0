Feature: Grab parser
  In order to manipulate datasets
  As a grab user
  I want the interpreter to act consistently

  Scenario: each line is executed in turn
    Given the Grab program is "row 1 \nrow 2"
    And the data source is the Array "[2,4]" 
    And I have bound the Grab executable to that data source 
    When I run the Grab executable
    Then the result should be the Array "[4,2]"

  Scenario: trailing junk does not affect recognition
    Given the Grab program is "row 1 foobar \nrow 2"
    And the data source is the Array "[2,4]" 
    And I have bound the Grab executable to that data source 
    When I run the Grab executable
    Then the result should be the Array "[4,2]"

  Scenario: run on instructions are ignored
    Given the Grab program is "row 1 all"
    And the data source is the Array "[2,4]" 
    And I have bound the Grab executable to that data source 
    When I run the Grab executable
    Then the result should be the Array "[4]"

  Scenario: preceding non-whitespace blocks recognition
    Given the Grab program is "row row 1"
    And the data source is the Array "[2,4]" 
    And I have bound the Grab executable to that data source 
    When I run the Grab executable
    Then the result should be the Array "[]"
