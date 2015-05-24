class CallbacksController < Devise::OmniauthCallbacksController
    def github
        @user = User.from_omniauth(request.env["omniauth.auth"])
        logger.debug "User created"
        logger.debug "#{@user.email}"
        sign_in_and_redirect @user
    end
end