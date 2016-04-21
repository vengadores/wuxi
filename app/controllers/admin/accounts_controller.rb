module Admin
  class AccountsController < ApplicationController
    before_action :authenticate_user!

    def index
      @accounts = Core::Account.all
    end

    def new
      @account = Core::Account.new
    end

    def create
      account = Core::Account.new(account_params)
      account.save!
      redirect_to action: :index
    end

    private

    def account_params
      params.require(:account)
            .permit(:name)
    end
  end
end
