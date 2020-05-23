require 'test_helper'

class ClapsControllerTest < ActionDispatch::IntegrationTest

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

    end

    test "should add a clap" do

        clap_params = {clapable_id: 11, clapable_type: "Post", post_id: 11}
        clap_payload = {"clap" => {"user_id"=>"1", "clapable_id"=>"11", "clapable_type"=>"Post"}}
        clap_response = 2
        stub_request(:post, Rails.application.credentials[:services][:post] + '/api/claps').
            with(
                body: clap_payload
                ).
            to_return(status: 200, body: clap_payload.to_json)
        post claps_path, params: clap_params

        assert_template :show[clap_params[:clapable_id]]
        assert_equal 302, response.status

    end

end