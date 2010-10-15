Feature: Headers
  In order to examine data structure in tables I've attached to
  As a grab user
  I want to be able to retrieve and rename field names, headers, column names &c


  Scenario: headers from an Array data_source without header info are bare 
    Given the Grab program is "row 2"
    And the data source is the Array "[7,6,5,4,3,2,1]" 
    And I have bound the Grab executable to that data source 
    Then the headers should be "[:grab_index, :column_1]"


  Scenario: headers from an Array data_source without Hash keys are those 
    Given the Grab program is "row 2"
    And the data source is the Array "[{foo:2, bar:3}, {foo:12, bar:1}]" 
    And I have bound the Grab executable to that data source 
    Then the headers should be "[:grab_index, :foo, :bar]"


  Scenario: headers from an Array data_source with different Hash keys in each row are the union of those 
    Given the Grab program is "row 2"
    And the data source is the Array "[{foo:2, bar:3}, {baz:12, bar:1}]" 
    And I have bound the Grab executable to that data source 
    Then the headers should be "[:grab_index, :foo, :bar, :baz]"
