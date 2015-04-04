Feature: Displaying

  Scenario Outline: Pagination
    Given I'm using <engine>
    And I have movies
      | title       | plot              |
      | Green Green | Blue Blue Blue    |
      | Blue Blue   | Green Green Green |
    When I enter a search query "Blue" with options "{page: 1, per_page: 1}"
    Then I should get results "['Blue Blue']"
    When I enter a search query "Blue" with options "{page: 2, per_page: 1}"
    Then I should get results "['Green Green']"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Highlighting
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "Green" with options "{highlight: true}"
    Then the first result should be "The <strong>Green</strong> Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |
