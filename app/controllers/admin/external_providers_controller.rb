module Admin
  class ExternalProvidersController < BaseController
    before_action :find_account

    def new
      session[:adding_external_provider] = {
        account_id: params[:account_id],
        at: Time.now
      }
    end

    def authorize
      @errors = session[:adding_external_provider]["errors"]
    end

    private

    def find_account
      @account = Core::Account.find(params[:account_id])
    end

    def supported_providers
      Core::ExternalProvider::SUPPORTED_PROVIDERS
    end

    def provider
      @provider ||= OpenStruct.new(
        name: params[:provider],
        link: supported_providers.fetch(params[:provider])
      )
    end
    helper_method :provider
  end
end
