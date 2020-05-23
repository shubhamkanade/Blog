Given(/^I visit the webpage$/) do
	visit users_path
end

When(/^I enter name as a 'Pournima'$/) do
	page.find('#name').set('Pournima')
end

And(/^I enter email as a 'pournima.bamane@techverito.com'$/) do
	page.find('#email').set('pournima.bamane@techverito.com')
end

And(/^I enter password as a 'pournima123'$/) do
	page.find('#password').set('pournima123')
end

Then(/^I submit the details$/) do
	params = {user: {name: 'Pournima',email: 'pournima.bamane@techverito.com',password: 'pournima123'}}
	stub_request(:post, Rails.application.credentials[:services][:user]+"/api/users").
		with(body: params.to_json).
		to_return(status: 200, body: "{}")

	params = { :user=>{ :email => "pournima.bamane@techverito.com", :password => "pournima123" } }
	response = {"user_id"=>41, "user_email"=>"pournima@techverito.com", "auth_token"=>"token"}
	stub_request(:post, Rails.application.credentials[:services][:user]+"/login").
		with(body: params.to_json,).
		to_return(status: 200, body: "")

	click_on("Register")
end

Then(/^I should see the login page$/) do
	page.has_button?("Login")
	expect(page).to have_content("Login")
end

Then(/^I click the register button$/) do
	params = {user: {name: 'Pournima',email: 'pournima.bamane@techverito.com',password: 'pournima123'}}
	response = {"errors"=>{"email"=>["has already been taken"]}}
	stub_request(:post, Rails.application.credentials[:services][:user]+"/api/users").
		with(body: params.to_json).
		to_return(status: 422, body: response.to_json)
	click_on("Register")
end

Then(/^I should see the error$/) do
	expect(page).to have_content("Email has already been taken")
end







