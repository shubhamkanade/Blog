require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

	setup do

		payload = {:email => "pournima.bamane@techverito.com", :password => "pournima123"}
		params = {"user"=>{"email"=>"pournima.bamane@techverito.com", "password"=>"pournima123"}}
		@user = {"user_id"=>1, "user_email"=>"pournima.bamane@techverito.com", "auth_token"=>"token","created_at"=> Time.now()}
		stub_request(:post, Rails.application.credentials[:services][:user] + "/login").
			with(
				body: params.to_json
				).
			to_return(status: 200, body: @user.to_json)
		post users_login_path , params: payload

		@post = {
			"id"=> 11,
			"user_id"=> 1,
			"title"=> "Rails post",
			"description"=> "This is rails post",
			"claps"=> 0,
			"created_at"=> Time.now(),
			"updated_at"=> Time.now()
		}

		@comments = { "comments" =>
			[{
				"id"=> 21,
				"user_id"=> 3,
				"post_id" => @post['id'],
				"comment"=> "Rails comment",
				"created_at"=> Time.now(),
				"updated_at"=> Time.now()
			},
			{
				"id"=> 22,
				"user_id"=> 3,
				"post_id" => @post['id'],
				"comment"=> "Rails new comment",
				"created_at"=> Time.now(),
				"updated_at"=> Time.now()
			}
		]}

		@post_response = {
			"post" =>
			{
				"id"=> 11,
				"user_id"=> 1,
				"title"=> "Rails post",
				"description"=> "This is rails post",
				"claps"=> 0,
				"created_at"=> Time.now(),
				"updated_at"=> Time.now()
			}
		}

		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts/" + @post['id'].to_s).
			to_return(status: 200, body: @post_response.to_json)

	end

	test "should redirect to all_posts_page on successfully creating a new post" do

		params = {
			"title"=> "title",
			"description"=> "description",
			"user_id"=> 1
		}
		payload = {post: {title: 'title',description: 'description',user_id: 1}}
		stub_request(:post, Rails.application.credentials[:services][:post] + "/api/posts").
			with(body: payload.to_json)

		post posts_path, params: params
		assert_redirected_to posts_path

	end

	test "should return all posts" do

		user = {user: {"user_id"=>1, "user_email"=>"pournima.bamane@techverito.com", "auth_token"=>"token","created_at"=> Time.now()}}
		posts = { "posts" => [{
			"id"=> 11,
			"user_id"=> 41,
			"title"=> "Rails post",
			"description"=> "This is rails post",
			"claps"=> 0,
			"created_at"=> Time.now(),
			"updated_at"=> Time.now()
			},
			{
			"id"=> 12,
			"user_id"=> 41,
			"title"=> "Rails post",
			"description"=> "This is rails post",
			"claps"=> 0,
			"created_at"=> Time.now(),
			"updated_at"=> Time.now()
			}
		]}
		stub_request(:get, Rails.application.credentials[:services][:user] + "/api/users/41").
		to_return(status: 200, body: user.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {clapable_id: 11,clapable_type: "Post"}
		).
		to_return(status: 200, body: {"claps": 0}.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/claps").
		with(
			body: {clapable_id: 12,clapable_type: "Post"}
		).
		to_return(status: 200, body: {"claps": 0}.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post] + "/api/posts").
		with(
			body: {"title"=> nil}
			).
		to_return(status: 200, body: posts.to_json)

		get posts_path, params: {"title"=> nil}
		assert_template :index
		assert_equal 200, response.status
		assert_equal posts["posts"].count, assigns(:posts).count
		assert_equal posts["posts"].first["id"], assigns(:posts).first["id"]
		assert_equal posts["posts"].last["id"], assigns(:posts).last["id"]

	end

	test "should show a particular post" do

		user = {user: {"user_id"=>1, "user_email"=>"pournima.bamane@techverito.com", "auth_token"=>"token","created_at"=> Time.now()}}

		stub_request(:get, Rails.application.credentials[:services][:post]+ "/api/comments/?post_id=" + @post['id'].to_s).
			to_return(status: 200, body: @comments.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post]+ "/api/claps").
			with(
				body: {"clapable_id"=>@post['id'], "clapable_type"=>"Post"}
				).
			to_return(status: 200, body: {"claps"=>0}.to_json)

		stub_request(:get, Rails.application.credentials[:services][:user]+ "/api/users/" + @post["user_id"].to_s ).
			to_return(status: 200, body: user.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post]+ "/api/claps").
			with(
				body: {"clapable_id"=>"21", "clapable_type"=>"Comment"}
				).
			to_return(status: 200, body: {"claps"=>0}.to_json)

		stub_request(:get, Rails.application.credentials[:services][:post]+ "/api/claps").
			with(
				body: {"clapable_id"=>"22", "clapable_type"=>"Comment"}
				).
			to_return(status: 200, body: {"claps"=>0}.to_json)

		stub_request(:get, Rails.application.credentials[:services][:user]+ "/api/users/3").
			to_return(status: 200, body: user.to_json)

		get post_path @post['id']

		assert_template :show
		assert_equal 200, response.status
		actual_post_id = assigns(:post)['id']
		assert_equal @post['id'], actual_post_id

	end

	test "should display a success flash message on successfully updating a post" do

		updated_post= {"updated_post" => {"title"=>"Rails post", "description"=>"This is UPDATED rails post", "user_id"=>"1"}}

		success_response = {"message" => "Successfully updated!"}
		stub_request(:patch, Rails.application.credentials[:services][:post] + "/api/posts/" + @post['id'].to_s).
		with(
			body: {"post" => {"title"=>"Rails post", "description"=>"This is rails post", "user_id"=>"1"}}
		).
		to_return(body: success_response.to_json)

		patch post_path @post["id"],@post

		assert_equal success_response["message"],flash[:success]
		assert_equal 302, response.status

		assert_redirected_to posts_path

	end

	test "should display a success flash message on successfully deleting a post" do

		success_response = {"message" => "Successfully deleted!"}

		stub_request(:delete, Rails.application.credentials[:services][:post] + "/api/posts/" + @post['id'].to_s).
		to_return(status: 200, body: success_response.to_json)
		delete post_path @post["id"]

		assert_equal 302, response.status
		assert_equal success_response["message"],flash[:success]
		assert_redirected_to posts_path

	end

end