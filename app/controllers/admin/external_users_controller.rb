module Admin
  class ExternalUsersController < BaseController
    before_action :find_external_user, only: [:show, :update_status]

    def index
      @status = params[:status] || 'new'
      @external_users = Core::ExternalUser.with_status(@status).page(params[:page])
    end

    def show
      @external_user = @external_user.decorate
      @status = @external_user.status
    end

    def update_status
      # probably service logic?
      external_user_params = {
        notes: params[:notes],
        status: params[:commit]
      }
      @external_user.update!(external_user_params)
      Core::Activity.create!(
        subject: @external_user,
        action: :external_user_status_update,
        whodunit_id: current_user.id,
        predicate: external_user_params
      )
      redirect_to action: :show, id: @external_user.id
    end

    private

    def find_external_user
      @external_user = Core::ExternalUser.find params[:id]
    end
  end
end
