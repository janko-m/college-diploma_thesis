Feature: Search

  Scenario Outline: Index
    Given I have papers
      | title                  |
      | Sok od crvenih naranča |

    # Case insensitivity
    When I search <engine> for "sok od crvenih naranča"
    Then I should get back papers
      | Sok od crvenih naranča |

    # Keywords (order unimportant)
    When I search <engine> for "Sok naranča"
    Then I should get back papers
      | Sok od crvenih naranča |

    # Keywords (all must be present)
    When I search <engine> for "Sok od crvenih jabuka"
    Then I should get back no papers

    # Stemming
    When I search <engine> for "Sok od crvene naranče"
    Then I should get back papers
      | Sok od crvenih naranča |

    # Stop words
    When I search <engine> for "Sok s crvenih naranča"
    Then I should get back papers
      | Sok od crvenih naranča |

    # Typo correction
    When I search <engine> for "Sol od crvenih naranča"
    Then I should get back papers
      | Sok od crvenih naranča |

    Examples:
      | engine   |
      | postgres |

  Scenario Outline: Query
    Given I have papers
      | title                  |
      | Sok od crvenih naranča |

    # AND operator
    When I search <engine> for "naranča AND breskva"
    Then I should get back no papers
    When I search <engine> for "naranča AND breskva"
    Then I should get back no papers

    # OR operator
    When I search <engine> for "jabuka OR breskva"
    Then I should get back no papers
    When I search <engine> for "naranča OR breskva"
    Then I should get back papers
      | Sok od crvenih naranča |

    # NOT operator
    When I search <engine> for "naranča -sok"
    Then I should get back no papers
    When I search <engine> for "naranča -breskva"
    Then I should get back papers
      | Sok od crvenih naranča |

    Examples:
      | engine   |
      | postgres |

  Scenario Outline: Ranking
    Given I have papers
      | title                  |
      | Sok od crvenih naranča |

    Examples:
      | engine   |
      | postgres |

  Scenario Outline: Display
    Given I have papers
      | title                  |
      | Sok od crvenih naranča |
