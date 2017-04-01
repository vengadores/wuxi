module Admin
  class AccountsController < BaseController
    before_action :find_account, only: [:edit, :update, :show]

    def index
      @accounts = Core::Account.all
    end

    def new
      @account = Core::Account.new
    end

    def edit
    end

    def show
      @external_providers = @account.external_providers.decorate
    end

    def create
      @account = Core::Account.new(account_params)
      if @account.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def update
      if @account.update(account_params)
        redirect_to action: :index
      else
        render :edit
      end
    end

    private

    def find_account
      @account = Core::Account.find params[:id]
    end

    def account_params
      params.require(:account)
            .permit(
              :name,
              external_providers_attributes: [:id, :_destroy],
              rules_attributes: [
                :id,
                :kind,
                :content,
                :allowed,
                :can_mention,
                :case_sensitive,
                :_destroy
              ]
            )
    end
  end
end
