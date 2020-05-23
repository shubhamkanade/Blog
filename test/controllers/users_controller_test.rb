require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

    test "should redirect to login page on successful user registration" do

        user_params = {
            "name" => "yash", "email" => "yash@techverito.com", "password" => "pwd"
        }
        payload = {"user" => {"name" => "yash", "email" => "yash@techverito.com", "password" =>  "pwd"}}
        stub_request(:post, Rails.application.credentials[:services][:user] + "/api/users").
        with(
            body: payload
            ).
        to_return(status: 200, body: user_params.to_json)
        post users_path, params: user_params
        assert_equal 302, response.status
        assert_redirected_to users_login_path

    end

    test "should display error message when user tries to register with existing email" do

        user_params = {
            "name" => "yash", "email" => "yash@techverito.com", "password" => "pwd"
        }
        payload = {"user" => {"name" => "yash", "email" => "yash@techverito.com", "password" =>  "pwd"}}
        error_response = {errors: { :email=>["has already been taken"]}}
        stub_request(:post, Rails.application.credentials[:services][:user] + "/api/users").
        with(
            body: payload
            ).
        to_return(status: 404, body: error_response.to_json)
        post users_path, params: user_params

        assert_equal 302, response.status
        assert_redirected_to users_path

    end

    test "renders all the posts on successful login" do

        user_params = {
            "email" => "yash@techverito.com", "password" => "pwd"
        }
        payload = {"user" => {"email" => "yash@techverito.com", "password" =>  "pwd"}}
        user_response = {
            "user_id"=>1, "user_email"=>"yash@techverito.com",
            "auth_token"=>"token", "created_at"=> Time.now()
        }

        stub_request(:post, Rails.application.credentials[:services][:user] + "/login").
        with(
            body: payload
            ).
        to_return(status: 200, body: user_response.to_json)

        post users_login_path, params: user_params

        assert_equal 302, response.status
        assert_redirected_to posts_path

        assert_equal user_response["auth_token"],session["current_user"]["auth_token"]

    end

    test "renders flash message on unsuccessful login" do

        user_params = {
            "email" => "yash@techverito.com", "password" => "pwd"
        }
        payload = {"user" => {"email" => "yash@techverito.com", "password" =>  "pwd"}}

        error_response = {"message" => "Invalid email or password"}
        stub_request(:post, Rails.application.credentials[:services][:user] + "/login").
        with(
            body: payload
            ).
        to_return(status: 404, body: error_response.to_json)

        post users_login_path, params: user_params
        assert_equal 302, response.status
        assert_redirected_to users_login_path
        assert_equal error_response["message"],flash[:alert]

    end

end