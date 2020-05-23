class UsersController < ApplicationController
    skip_before_action :verify_token

    def create
        url = Rails.application.credentials[:services][:user] + '/api/users'
        payload = {user: {name: params["name"],email: params["email"],password: params["password"]}}
        response = RestClient.post(url, payload.to_json, {'content-type' => 'application/json'}) do |response, request|
            if response.code == 200
                redirect_to users_login_path, method: :post
            else
                message = JSON.parse(response)["errors"]["email"][0]
                flash[:alert] = "Email " + message
                redirect_to users_path
            end
         end
    end

    def login
        url = Rails.application.credentials[:services][:user] + '/login'
        payload = {user: {email: params["email"],password: params["password"]}}
        response = RestClient.post(url, payload.to_json, {'content-type' => 'application/json'}) do |response, request|
            response = JSON.parse(response.body)
            if  response['user_id'] && response['user_email'] && response['auth_token']
                session[:current_user] = response
                redirect_to posts_path, method: :get
            else
                redirect_to users_login_path, alert: response['message']
            end
        end
    end

end
