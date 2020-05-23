When(/^I delete my post$/)do
	@post = {
		"id"=>1,
		"user_id"=>1,
		"title"=>"Rails post",
		"description"=>"This is rails post",
		"claps"=>0,
		"created_at"=>Time.now(),
		"updated_at"=>Time.now()
	}

	stub_request(:delete, Rails.application.credentials[:services][:post] + "/api/posts/1").
		to_return(status: 200, body: @post.to_json)

	stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts/1").
		to_return(status: 200, body: @post.to_json, headers: {})

	page.find("#delete").click
	accept_alert
end

Then(/^I should be able to see the successful mesaage for deleting post$/) do
end