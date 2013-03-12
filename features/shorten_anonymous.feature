Feature: Shorten URL as an Anonymous User

  Scenario: Shorten URL
    Given that I am an anonymous user of the system
    When I visit the site
    And give a URL to the service
    Then I expect it to return a service shortened URL