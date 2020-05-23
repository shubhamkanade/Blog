Given(/^I visit the login page of the webpage$/)do
    visit users_login_path
end

Then(/^I click on login button$/) do
	params = { :user=>{ :email => "pournima.bamane@techverito.com", :password => "pournima123" } }
	response = "{\"user_id\":1,\"user_email\":\"pournima.bamane@techverito.com\",\"auth_token\":\"token\"}"
	stub_request(:post, Rails.application.credentials[:services][:user] + "/login").
		with(body: params.to_json,).
		to_return(status: 200, body: response)

	posts = {
		"posts": [{
			"id": 1,
			"user_id": 1,
			"title": "Rails post",
			"description": "This is rails post",
			"claps": 0,
			"created_at": "2020-02-21T09:35:48.587Z"
		}]
	}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts").
		with(
			body: {"title"=>nil},
		).
		to_return(status: 200, body: posts.to_json)

	user = {
		"id": 1,
		"name": "pournima",
		"email": "pournima.bamane@techverito.com",
		"password": "pournima123",
		"created_at": "2020-02-21T09:35:48.587Z"
	}
	stub_request(:get, Rails.application.credentials[:services][:user] + "/api/users/1").
		to_return(status: 200, body: user.to_json)

	payload = {:clapable_id=>28, :clapable_type=>"Post"}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(body: payload).
	to_return(status: 200, body: "")

	click_on("Login")
end

And(/^I enter password as a 'pournima'$/) do
	page.find('#password').set('pournima')
end

Then(/^I click the login button$/) do
	params1 = {
		:user=>{
			:email => "pournima.bamane@techverito.com",
			:password => "pournima"
			}
		 }
	response = {"message": "Invalid email or password"}

	stub_request(:post, Rails.application.credentials[:services][:user] + "/login").
		with(body: params1.to_json,).
		to_return(body: response.to_json)
	click_on("Login")
end

Then(/^I should see the error message$/) do
	expect(page).to have_content('Invalid email or password')
end
