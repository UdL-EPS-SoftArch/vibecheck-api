Feature: Edit and delete comment
  In order to keep event discussions under their authors' control
  As an Erasmus student
  I want to edit and delete only my own comments

  Background:
    Given a category named "Social" exists
    And a subcategory named "Meetups" belongs to category "Social"
    And There is a registered user with username "luca" and password "password" and email "luca@sample.app"
    And an event titled "Welcome picnic" exists and is owned by "amina"
    And a comment with content "Original comment" exists on the event titled "Welcome picnic" and is authored by "luca"

  Scenario: The author edits their own comment
    Given I login as "luca" with password "password"
    When I edit the comment with content "Original comment" to "Edited comment"
    Then The response code is 200
    And the comment with content "Edited comment" still exists

  Scenario: The author cannot blank their own comment
    Given I login as "luca" with password "password"
    When I edit the comment with content "Original comment" to ""
    Then The response code is 400
    And the comment with content "Original comment" still exists

  Scenario: A student cannot edit a comment written by someone else
    Given There is a registered user with username "marta" and password "password" and email "marta@sample.app"
    And I login as "marta" with password "password"
    When I edit the comment with content "Original comment" to "Hijacked comment"
    Then The response code is 403
    And the comment with content "Original comment" still exists

  Scenario: An unauthenticated visitor cannot edit a comment
    Given I'm not logged in
    When I edit the comment with content "Original comment" to "Anonymous edit"
    Then The response code is 401
    And the comment with content "Original comment" still exists

  Scenario: The author deletes their own comment
    Given I login as "luca" with password "password"
    When I delete the comment with content "Original comment"
    Then The response code is 204
    And the comment with content "Original comment" no longer exists

  Scenario: An unauthenticated visitor cannot delete a comment
    Given I'm not logged in
    When I delete the comment with content "Original comment"
    Then The response code is 401
    And the comment with content "Original comment" still exists
