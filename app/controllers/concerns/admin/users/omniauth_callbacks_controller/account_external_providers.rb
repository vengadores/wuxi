module Admin
  module Users
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      module AccountExternalProviders
        private

        def account_id
          @account_id ||= session[:adding_external_provider]["account_id"]
        end

        def authorized_provider
          Core::ExternalProvider.authorize(
            account_id,
            request.env["omniauth.auth"]
          )
        end

        def authorize_account_provider!
          if authorized_provider.valid?
            session.delete(:adding_external_provider)
            redirect_to edit_admin_account_path(
              id: account_id
            )
          else
            session[:adding_external_provider][:errors] = authorized_provider.errors.full_messages
            redirect_to authorize_admin_account_external_providers_path(
              account_id: account_id
            )
          end
        end

        def adding_external_provider?
          session[:adding_external_provider].present? && attempted_to_add_recently?
        end

        def attempted_to_add_recently?
          allowed_time = 15.minutes
          at = Time.parse(session[:adding_external_provider]["at"])
          Time.now - at < allowed_time
        end
      end
    end
  end
end
