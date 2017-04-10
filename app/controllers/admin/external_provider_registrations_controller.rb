module Admin
  class ExternalProviderRegistrationsController < BaseController
    def new
      send "authorize_#{params[:provider]}"
    end

    def show
      ##
      # TODO
      # in fact, this is #create
      twitter_authorization = session[:twitter_authorization]
      twitter_authorization.verify_oauth!(
        oauth_verifier: params[:oauth_verifier]
      )
      external_provider = twitter_authorization.build_external_provider
      if external_provider.save
        session.delete(:twitter_authorization)
        redirect_to edit_admin_account_path(
          id: params[:account_id]
        )
      else
        session[:adding_external_provider][:errors] = external_provider.errors.full_messages
        redirect_to authorize_admin_account_external_providers_path(
          account_id: params[:account_id]
        )
      end
    end

    private

    def authorize_twitter
      # session[:request_token] = twitter_authorization.request_token
      twitter_authorization = get_twitter_authorization
      session[:twitter_authorization] = twitter_authorization
      redirect_to twitter_authorization.authorize_url
    end

    def get_twitter_authorization
      Core::ExternalProvider::TwitterAuthorizationService.new(
        account_id: params[:account_id]
      )
    end
  end
end
