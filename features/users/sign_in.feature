Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Scenario: User is not signed up
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an invalid login message
        And I should be signed out

    Scenario: User signs in successfully
      Given I exist as a user
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in

    Scenario: User enters wrong email
      Given I exist as a user
      And I am not logged in
      When I sign in with a wrong email
      Then I see an invalid login message
      And I should be signed out
      
    Scenario: User enters wrong password
      Given I exist as a user
      And I am not logged in
      When I sign in with a wrong password
      Then I see an invalid login message
      And I should be signed out

    Scenario: User is not confirmed
      Given I exist as an unconfirmed user
      And I am not logged in
      When I sign in with valid credentials
      Then I see an unconfirmed account message
      
    Scenario: User is redirected to a sign in screen if attempting to access protected content
      Given I exist as a user
      And I am not logged in
      When I try to access protected content
      Then I am redirected to a sign in screen

    Scenario: User is redirected to protected content after signing in
      Given I exist as a user
      And I am not logged in
      And I try to access protected content
      When I sign in with valid credentials
      Then I am redirected to the protected content