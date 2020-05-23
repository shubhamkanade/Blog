class PostsController < ApplicationController
    before_action :verify_token

    def index
        payload = {title: params['title']}
        url = Rails.application.credentials[:services][:post] + '/api/posts'
        response = RestClient::Request.execute method: :get, url: url, action: :index, payload: payload do |response, request|
            @posts = JSON.parse(response)['posts']
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    def create
        url = Rails.application.credentials[:services][:post] + '/api/posts'
        payload = {post: {title: params['title'],description: params['description'],user_id: session[:current_user]['user_id']}}
        response = RestClient.post(url, payload.to_json, {'content-type' => 'application/json'}) do |response, request|
            if response.code == 200
                redirect_to posts_path
            end
        end
    end

    def new
    end

    def show
        @post = find_post_by_id params[:id]
        url = Rails.application.credentials[:services][:post] + '/api/comments/'
        response = RestClient.get url, { params: {post_id: @post["id"] }}
        @comments = JSON.parse(response.body)['comments']
    end

    def update
        url = Rails.application.credentials[:services][:post] + '/api/posts/' + params[:id]
        payload = { post: {title: params[:title], description: params[:description], user_id: params[:user_id]}}
        RestClient::Request.execute method: :patch, url: url, action: :update, payload: payload do |response, request|
            flash[:success] = JSON.parse(response.body)["message"]
            redirect_to posts_path
        end
    end

    def destroy
        post = find_post_by_id(params["id"])
        redirect_to posts_path if !user_has_post_rights? post["user_id"]
        url = Rails.application.credentials[:services][:post] + '/api/posts/' + params[:id]
        RestClient::Request.execute method: :delete, url: url, action: :destroy do |response, request|
            flash[:success] = JSON.parse(response.body)["message"]
            redirect_to posts_path
        end
    end

    def edit
        @post = find_post_by_id(params["id"])
        redirect_to posts_path if !user_has_post_rights? @post["user_id"]
    end

    private
    def user_has_post_rights? user_id_from_post
        return true if user_id_from_post == session[:current_user]["user_id"]
        false
    end

    def find_post_by_id post_id
        url = Rails.application.credentials[:services][:post] + '/api/posts/' + post_id
        RestClient::Request.execute method: :get, url: url, action: :show do |response, request|
            @post = JSON.parse(response.body)["post"]
        end
    end

end