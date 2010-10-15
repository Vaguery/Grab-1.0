Feature: Csv data source
  In order to learn from standard flat text files
  As a grab user
  I want to be able to manipulate csv files as data sources


  Scenario: If csv has headers and all columns filled, headers = csv headers
    # x1,x2,x3,y1,y2
    # 1,2,3,4,5
    # 5,6,7,8,9
    # 9,10,11,12,13
    
  Scenario: If csv lacks headers, but all columns are filled, headers = inferred column names
    Given context
    When event
    Then outcome
  
  Scenario: If csv has headers and all columns, but some rows have empty elements, those cells have no values
    Given context
    When event
    Then outcome
  
  Scenario: If csv has headers, but extra columns in some rows, use inferred headers for extra columns
    Given context
    When event
    Then outcome
  
  Scenario: If csv has no headers, and unequal column counts in rows, infer from max length
    Given context
    When event
    Then outcome
  
  Scenario: type information
    Given context
    When event
    Then outcome
  
  
  
  
  
  
  
  
  
