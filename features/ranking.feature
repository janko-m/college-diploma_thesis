Feature: Ranking

  Scenario Outline: TF-IDF
    Given I'm using <engine>
    And I have movies
      | title | plot |
      | Blue  | The Blue Blue Blue Lagoon |
      | Blue  | The Blue Lagoon |
    When I enter a search query "Mile Green"
    Then the results should contain "The Green Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Field weights
    Given I'm using <engine>
    And I have movies
      | title   |
      | Journal |
    When I enter a search query "Magazine"
    Then the results should contain "Journal"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Word proximity
    Given I'm using <engine>
    And I have movies
      | title       |
      | The Green Mile |
    When I enter a search query "The Gren Mile"
    Then the results should contain "The Green Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |
