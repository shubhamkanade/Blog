Feature: As a user I should be able to view the post
	Background:
		Given I visit the login page of the webpage
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click on login button

	Scenario: As a user I am able to view the post
		When I click on view link on last post
		Then I am able to see the post