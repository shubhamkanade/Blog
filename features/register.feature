Feature: As a user I should be able to register with my details
	Background:
		Given I visit the webpage

	Scenario: As a user I am able to register my account
		When I enter name as a 'Pournima'
		And I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I submit the details
		Then I should see the login page
		
	Scenario: Application should show error if email id is already exist
		When I enter name as a 'Pournima'
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click the register button
		And I should see the error

