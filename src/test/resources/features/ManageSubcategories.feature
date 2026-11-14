Feature: Manage subcategories
  In order to keep event subcategories consistent
  As an administrator
  I want only admins to create and delete subcategories

  Background:
    Given a category named "Social" exists

  Scenario: A standard user cannot create a subcategory
    Given There is a registered user with username "category-user" and password "password" and email "category-user@sample.app"
    And I login as "category-user" with password "password"
    When I create a subcategory named "User-created subcategory" in category "Social"
    Then The response code is 403
    And the subcategory named "User-created subcategory" has not been created

  Scenario: An unauthenticated visitor cannot create a subcategory
    Given I'm not logged in
    When I create a subcategory named "Visitor-created subcategory" in category "Social"
    Then The response code is 401
    And the subcategory named "Visitor-created subcategory" has not been created

  Scenario: An admin can create a subcategory
    Given an admin user exists
    And I login as an admin
    When I create a subcategory named "Admin-created subcategory" in category "Social"
    Then The response code is 201
    And the subcategory named "Admin-created subcategory" has been created

  Scenario: An admin cannot create a subcategory without a name
    Given an admin user exists
    And I login as an admin
    When I create a subcategory named "" in category "Social"
    Then The response code is 400

  Scenario: An admin cannot create a subcategory without a category
    Given an admin user exists
    And I login as an admin
    When I create a subcategory named "Orphan subcategory" without a category
    Then The response code is 400
    And the subcategory named "Orphan subcategory" has not been created

  Scenario: A standard user cannot delete a subcategory
    Given a subcategory named "Protected subcategory" belongs to category "Social"
    And There is a registered user with username "category-user" and password "password" and email "category-user@sample.app"
    And I login as "category-user" with password "password"
    When I delete the subcategory named "Protected subcategory"
    Then The response code is 403
    And the subcategory named "Protected subcategory" still exists

  Scenario: An admin can delete a subcategory
    Given a subcategory named "Admin-deleted subcategory" belongs to category "Social"
    And an admin user exists
    And I login as an admin
    When I delete the subcategory named "Admin-deleted subcategory"
    Then The response code is 200
    And the subcategory named "Admin-deleted subcategory" no longer exists
