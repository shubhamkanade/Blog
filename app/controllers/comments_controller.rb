class CommentsController < ApplicationController
    before_action :verify_token

    def create
        url = Rails.application.credentials[:services][:post] + '/api/comments/'
        payload = { comment: {
            comment: params[:comment],
            post_id: params[:post_id],
            user_id: params[:user_id]
        }}
        response = RestClient.post url, payload.to_json, content_type: 'application/json'
        @comment = JSON.parse(response.body)
        redirect_to post_path(params[:post_id])
    end

end