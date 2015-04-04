Feature: Indexing

  Scenario Outline: Downcasing
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "the green mile"
    Then the first result should be "The Green Mile"

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
    Then the first result should be "The Green Mile"

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
    Then the first result should be "Un prophète"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |

  Scenario Outline: Stemming
    Given I'm using <engine>
    And I have movies
      | title |
      | Chair   |
    When I enter a search query "Chairs"
    Then the first result should be "Chair"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      | sphinx        |
