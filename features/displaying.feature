Feature: Displaying

  Scenario Outline: Pagination
    Given I'm using <engine>
    And I have movies
      | title      |
      | Blue       |
      | Blue Green |
    When I enter a search query "Blue" with options "{page: 1, per_page: 1}"
    Then I should get results "['Blue']"
    When I enter a search query "Blue" with options "{page: 2, per_page: 1}"
    Then I should get results "['Blue Green']"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      # | solr          |
      # | sphinx        |

  Scenario Outline: Highlighting
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "Green" with options "{highlight: true}"
    Then I should get results "['The <strong>Green</strong> Mile']"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      # | solr          |
      # | sphinx        |
