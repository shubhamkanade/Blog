When(/^I click on view link on last post$/) do
	@post = {
		"id"=>1,
		"user_id"=>1,
		"title"=>"Rails post",
		"description"=>"This is rails post",
		"claps"=>0,
		"created_at"=>Time.now(),
		"updated_at"=>Time.now()
	}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts/1").
		to_return(status: 200, body:@post.to_json)

	comments = {
		"comments"=>[{
			"id"=>1,
			"user_id"=>1,
			"post_id"=>23,
			"comment"=>"nice",
			"claps"=>0,
			"created_at"=>Time.now(),
			"updated_at"=>Time.now()
		}]
	}

	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/comments/?post_id=1").
			to_return(status: 200, body: comments.to_json)

	user = {
		"id": 1,
		"name": "pournima",
		"email": "pournima.bamane@techverito.com",
		"password": "pournima123",
		"created_at": Time.now()
	}

	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/users/1").
		to_return(status: 200, body: user.to_json)

		response = {"claps": 2}
		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {"clapable_id"=>"1", "clapable_type"=>"Post"}).
		to_return(status: 200, body: response.to_json)
	click_on "View"
end

Then(/^I am able to see the post$/) do
	response = {"claps": 2}
		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {"clapable_id"=>"1", "clapable_type"=>"Comment"}).
		to_return(status: 200, body: response.to_json)

	title =  @post['title']
	expect(page).to have_content(title)

	description = @post['description']
	expect(page).to have_content(description)
end