Feature: As a user I should be able to add comment on the post
	Background:
		Given I visit the login page of the webpage
		When I enter email as a 'pournima.bamane@techverito.com'
		And I enter password as a 'pournima123'
		Then I click on login button
		When I click on view link on last post
		Then I am able to see the post

	Scenario: As a user I am able to add comment on the post
		When I add comment as a "Useful post"
		And I click the comment button
		Then I should see my comment in comment box with my email id
