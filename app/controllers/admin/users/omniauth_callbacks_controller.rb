module Admin
  module Users
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      def twitter
        user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "twitter") if is_navigational_format?
      end

      private

      def new_session_path(scope)
        new_user_session_path
      end
    end
  end
end
