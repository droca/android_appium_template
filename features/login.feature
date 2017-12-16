Feature: Login to the application

  Background: Install and search for the app
    Given I have the app installed
    When I launch the app
    And I select the Test domain
    And I swipe to the left side
    And I click the SignIn button

  @all @negative
  Scenario: Login with invalid credentials
    When I try to login using invalid credentials
    Then An 'incorrect credentials' error message is shown
    And I'm not logged in

  @all @negative
  Scenario: Login without providing a password
    When I try to login without providing a password
    Then A 'fill in both fields' error message is shown
    And I'm not logged in

  @all @negative
  Scenario: Login without providing an email
    When I try to login without providing an email
    Then A 'fill in both fields' error message is shown
    And I'm not logged in

  @all @smoke
  Scenario: Login with valid credentials
    When I try to login using valid credentials
    Then I'm logged in
