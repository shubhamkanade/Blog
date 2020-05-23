Feature: As a user I should be able to create new post
	Background:
		Given I visit the login page of the webpage
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click on login button
		
	Scenario: As a user I am able to create new post
		When I navigate to new tab
		Then I enter the title
		And I enter the description
		And I click the save button
		Then I should be able to see my post on home page