Feature: Ranking

  Scenario Outline: TF-IDF
    Given I'm using <engine>
    And I have movies
      | title                    |
      | Blue Blue Blue Red       |
      | Blue Blue Red Red        |
      | Blue Blue Blue Blue Blue |
    When I enter a search query "Red Blue"
    Then the first result should be "Blue Blue Red Red"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      # | solr          |
      # | sphinx        |

  Scenario Outline: Field weights
    Given I'm using <engine>
    And I have movies
      | title       | plot              |
      | Green Green | Blue Blue Blue    |
      | Blue Blue   | Green Green Green |
    When I enter a search query "Green"
    Then the first result should be "Green Green"
    When I enter a search query "Blue"
    Then the first result should be "Blue Blue"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      # | solr          |
      # | sphinx        |

  Scenario Outline: Word proximity
    Given I'm using <engine>
    And I have movies
      | title                                  |
      | The word1 Green word2 word3 word4 Mile |
      | The Green Mile word1 word2 word3 word4 |
    When I enter a search query "The Green Mile"
    Then the first result should be "The Green Mile word1 word2 word3 word4"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      # | solr          |
      # | sphinx        |
