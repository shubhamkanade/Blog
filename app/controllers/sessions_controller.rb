class SessionsController < ApplicationController

    def destroy
        session.delete(:current_user)
        redirect_to users_login_path
    end

end