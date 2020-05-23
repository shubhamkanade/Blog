When(/^I add comment as a "Useful post"$/) do
	page.find("#comment").set("Useful post")
end

And(/^I click the comment button$/) do

	@comment = {:comment=>{:comment=>"Useful post", :post_id=>"1", :user_id=>"1"}}
	response = {"comment"=>{"id"=>1, "user_id"=>1, "post_id"=>1, "comment"=>"Useful post", "claps"=>1, "created_at"=>Time.now(), "updated_at"=>Time.now()}}
	stub_request(:post, Rails.application.credentials[:services][:post] + "/api/comments/").
		with(body: @comment.to_json).
		to_return(status: 200, body: response.to_json)

	@post = {
		"id"=>1,
		"user_id"=>1,
		"title"=>"Rails post",
		"description"=>"This is rails post",
		"claps"=>1,
		"created_at"=>Time.now(),
		"updated_at"=>Time.now()
	}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts/1").
		to_return(status: 200, body:@post.to_json, headers: {})

	comments = {
		"comments"=>[{
			"id"=>1,
			"user_id"=>1,
			"post_id"=>1,
			"comment"=>"Useful post",
			"claps"=>1,
			"created_at"=>Time.now(),
			"updated_at"=>Time.now()
		}]
	}

	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/comments/?post_id=1").
		to_return(status: 200, body: comments.to_json)

	@user = {
		"id": 1,
		"name": "pournima",
		"email": "pournima.bamane@techverito.com",
		"password": "pournima123",
		"created_at": Time.now
	}

	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/users/1").
		to_return(status: 200, body: @user.to_json)

	response = {"claps": 0}
	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {"clapable_id"=>"1", "clapable_type"=>"Comment"}
			).
		to_return(status: 200, body: response.to_json)
	click_on("Comment")
end

Then(/^I should see my comment in comment box with my email id$/) do
	expect(page).to have_content(@comment[:comment][:comment])
	expect(page).to have_content(@user[:email])
end