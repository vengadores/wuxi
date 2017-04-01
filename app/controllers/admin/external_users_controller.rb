module Admin
  class ExternalUsersController < BaseController
    before_action :find_external_user, only: [:show]

    def index
      @status = params[:status] || 'new'
      @external_users = Core::ExternalUser.with_status(@status).page(params[:page])
    end

    def show
      @external_user = @external_user.decorate
      @status = @external_user.status
    end

    private

    def find_external_user
      @external_user = Core::ExternalUser.find params[:id]
    end
  end
end
