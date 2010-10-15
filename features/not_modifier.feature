Feature: Not modifier
  In order to remove items and build complex subsets of data
  As a grab user
  I want a boolean NOT operation to apply to some instructions

  Scenario: not row [number]
    Given the Grab program is "all\nnot  3\nnot  1"
    And the data source is the Array "[2,4,6,8,10]"
    And I have bound the Grab executable to that data source
    When I run the Grab executable
    Then the result should be the Array "[2,6,10]"

  Scenario: repeated not row [number]
    Given the Grab program is "all\nnot 3\nnot  3"
    And the data source is the Array "[2,4,6,8,10]"
    And I have bound the Grab executable to that data source
    When I run the Grab executable
    Then the result should be the Array "[2, 4, 6, 10]"

  Scenario: "not row any"
    Given the Grab program is " 0 \n  1 \n not any"
    And the data source is the Array "[888, 888]"
    And I have bound the Grab executable to that data source
    When I run the Grab executable
    Then the result should be the Array "[]"

  Scenario: "not all"
    Given the Grab program is "all \n all \n not all"
    And the data source is the Array "[1,2,3]"
    And I have bound the Grab executable to that data source
    When I run the Grab executable
    Then the result should be the Array "[]"
