class ApplicationController < ActionController::Base
    before_action :verify_token

    def verify_token
      redirect_to users_login_path if session[:current_user].nil?
    end
end
