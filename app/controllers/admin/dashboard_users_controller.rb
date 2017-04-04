module Admin
  class DashboardUsersController < BaseController
    def index
      @role = params[:role] || 'user'
      @admin_users = Admin::User.with_role(@role)
    end
  end
end
