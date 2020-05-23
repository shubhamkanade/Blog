Feature: As a user I should be able to delete the post
	Background:
		Given I visit the login page of the webpage
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click on login button
		When I navigate to new tab
		Then I enter the title
		And I enter the description
		And I click the save button
		Then I should be able to see my post on home page
		
	Scenario: As a user I am able to delete my post
		When I delete my post
		Then I should be able to see the successful mesaage for deleting post