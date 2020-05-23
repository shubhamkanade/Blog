module ApplicationHelper
    def find_user_by_id id
        url = Rails.application.credentials[:services][:user] + '/api/users/' + id
        response = RestClient::Request.execute method: :get, url: url, action: :show do |response, request|
            JSON.parse(response.body)['user']
        end
    end

    def find_current_user
        session[:current_user]
    end

    def get_clap_count clapable_id, type
        url = Rails.application.credentials[:services][:post] + '/api/claps'
        payload = {clapable_id: clapable_id,clapable_type: type}
        RestClient::Request.execute method: :get, url: url, action: :index, payload: payload do |response, request|
            JSON.parse(response.body)['claps']
        end
    end
end
