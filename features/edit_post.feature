Feature: As a user I should be able to edit the post
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
		
	Scenario: As a user I am able to edit my post
		When I edit the post
		Then I edit the title as a 'Edited post title'
		And I edit the description as a 'Edited post description'
		And I click on Update button
		Then I should be able to see the edited title and description