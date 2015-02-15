Feature: Indexing

  Scenario Outline: Downcasing
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "the green mile"
    Then the results should contain "The Green Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Stopwords
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "A Green Mile"
    Then the results should contain "The Green Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Unaccenting
    Given I'm using <engine>
    And I have movies
      | title       |
      | Un prophète |
    When I enter a search query "Un prophete"
    Then the results should contain "Un prophète"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Stemming
    Given I'm using <engine>
    And I have movies
      | title  |
      | Octopi |
    When I enter a search query "Octopus"
    Then the results should contain "Octopi"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |
