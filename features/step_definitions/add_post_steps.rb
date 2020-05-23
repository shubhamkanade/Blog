Given(/^I visit the home page of the application$/) do
	visit posts_path
end

When(/^I navigate to new tab$/) do
	response = {"claps": 0}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {"clapable_id"=>"1", "clapable_type"=>"Post"},
			).
		to_return(status: 200, body: response.to_json)
	click_on 'New'
end

Then(/^I enter the title$/) do
	page.find('#title').set("title")
end

And(/^I enter the description$/) do
	page.find('#description').set("description")	
end

And(/^I click the save button$/) do
	post = {
		"post"=> {
			"id"=> 11,
			"user_id"=> 41,
			"title"=> "Rails post",
			"description"=> "This is rails post",
			"claps"=> 0,
			"created_at"=> Time.now(),
			"updated_at"=> Time.now()
		}
	}
	payload = {
		"post"=> {
			"title"=> "title",
			"description"=> "description",
			"user_id"=> 1
		}
	}

	stub_request(:post, Rails.application.credentials[:services][:post] + "/api/posts").
		with(body: payload.to_json,headers: {'Content-Type'=>'application/json'}).
		to_return(status: 200, body:post.to_json, headers: {})

	@posts = {
		"posts": [{
			"id": 1,
			"user_id": 1,
			"title": "Rails post",
			"description": "This is rails post",
			"claps": 0,
			"created_at": Time.now()
		}]
	}

	stub_request(:get, Rails.application.credentials[:services][:post]+ "/api/posts").
		with(	body: {"title"=>nil}).
		to_return(status: 200, body: @posts.to_json)
		
	click_on 'Save'
end

And(/^I should be able to see my post on home page$/) do
	title = @posts[:posts][0][:title]
	expect(page).to have_content(title)

	description = @posts[:posts][0][:description]
	expect(page).to have_content(description)
end