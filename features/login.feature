Feature: As a user I should be able to login into the application
	Background:
		Given I visit the login page of the webpage

	Scenario: As a user I am able to login into the application
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click on login button

	Scenario: Application should show error if I provide invalid credentials
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima'
		Then I click the login button
		Then I should see the error message
