module Admin
  class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_account, only: [:edit, :update]

    def index
      @accounts = Core::Account.all
    end

    def new
      @account = Core::Account.new
    end

    def edit
    end

    def create
      account = Core::Account.new(account_params)
      account.save!
      redirect_to action: :index
    end

    def update
      @account.update(account_params)
      redirect_to action: :index
    end

    private

    def find_account
      @account = Core::Account.find params[:id]
    end

    def account_params
      params.require(:account)
            .permit(:name)
    end
  end
end
