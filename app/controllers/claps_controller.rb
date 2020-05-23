class ClapsController < ApplicationController

    def create
        url = Rails.application.credentials[:services][:post] + '/api/claps'
        payload = {clap: {user_id: session[:current_user]['user_id'], clapable_id: params['clapable_id'],clapable_type: params['clapable_type']}}
        response = RestClient::Request.execute method: :post, url: url, action: :create, payload: payload do |response, request|
            redirect_to post_path params['post_id']
        end
    end

end