Feature: Querying

  Scenario Outline: Keywords
    Given I'm using <engine>
    And I have movies
      | title          |
      | The Green Mile |
    When I enter a search query "Mile Green"
    Then the first result should be "The Green Mile"
    When I enter a search query "Mile Green Apple"
    Then the results should be empty

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Synonym expansion
    Given I'm using <engine>
    And I have movies
      | title   |
      | Journal |
    When I enter a search query "Magazine"
    Then the first result should be "Journal"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Typos
    Given I'm using <engine>
    And I have movies
      | title       |
      | The Green Mile |
    When I enter a search query "The Gren Mile"
    Then the first result should be "The Green Mile"

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Phrases
    Given I'm using <engine>
    And I have movies
      | title  |
      | The Green Mile |
    When I enter a search query ""Green Mile""
    Then the first result should be "The Green Mile"
    When I enter a search query ""Mile green""
    Then the results should be empty

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Boolean operators
    Given I'm using <engine>
    And I have movies
      | title  |
      | The Green Mile |

    When I enter a search query "Green AND Mile"
    Then the first result should be "The Green Mile"
    When I enter a search query "Green AND Blue"
    Then the results should be empty

    When I enter a search query "Green OR Blue"
    Then the first result should be "The Green Mile"
    When I enter a search query "Blue OR Red"
    Then the results should be empty

    When I enter a search query "Green NOT Blue"
    Then the first result should be "The Green Mile"
    When I enter a search query "Green -Mile"
    Then the results should be empty

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Wildcards
    Given I'm using <engine>
    And I have movies
      | title  |
      | The Green Mile |

    When I enter a search query "Gr*"
    Then the first result should be "The Green Mile"
    When I enter a search query "Gb*"
    Then the results should be empty

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |

  Scenario Outline: Facets
    Given I'm using <engine>
    And I have movies
      | title          | year |
      | The Green Mile | 1999 |

    When I enter a search query "The Green Mile" with options "{year: "1999"}"
    Then the first result should be "The Green Mile"
    When I enter a search query "The Green Mile" with options "{year: "1998"}"
    Then the results should be empty

    When I enter a search query "The Green Mile" with options "{year: ">1998"}"
    Then the first result should be "The Green Mile"
    When I enter a search query "The Green Mile" with options "{year: "<1998"}"
    Then the results should be empty

    Examples:
      | engine        |
      | postgres      |
      | elasticsearch |
      | solr          |
      # | sphinx        |
