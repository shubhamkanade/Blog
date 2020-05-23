When(/^I edit the post$/) do
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

	page.find("#edit").click
end

Then(/^I edit the title as a 'Edited post title'$/) do
	page.find('#title').set("Edited post title")
end

Then(/^I edit the description as a 'Edited post description'$/) do
	page.find('#description').set("Edited post description")
end

Then(/^I click on Update button$/) do
	@post = {
		"id"=>1,
		"user_id"=>1,
		"title"=>"Rails post",
		"description"=>"This is rails post",
		"claps"=>0,
		"created_at"=>Time.now(),
		"updated_at"=>Time.now()
	}
	stub_request(:patch, Rails.application.credentials[:services][:post] + "/api/posts/1").
		with(
			body: {
				"post"=>{
					"title"=>"Edited post title",
					"description"=>"Edited post description",
					"user_id"=>"1"
					}
				}).
		to_return(status: 200, body: @post.to_json)
	click_on 'Update'
end

Then(/^I should be able to see the edited title and description$/) do
	stub_request(:patch, Rails.application.credentials[:services][:post] + "/api/posts/1").
	with(
		body: {
			"post"=>{
				"title"=>"Edited post title",
				"description"=>"Edited post description",
				"user_id"=>"1"
				}
			},
		).
	to_return(status: 200, body: "")

	title =  @post['title']
	expect(page).to have_content(title)

	description = @post['description']
	expect(page).to have_content(description)
end