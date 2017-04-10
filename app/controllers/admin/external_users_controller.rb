module Admin
  class ExternalUsersController < BaseController
    before_action :find_external_user,
                  only: [
                    :show,
                    :update_status,
                    :analyse_latest_posts
                  ]

    def index
      @status = params[:status] || 'new'
      @external_users = Core::ExternalUser.with_status(@status).page(params[:page])
    end

    def show
      @external_user = @external_user.decorate
      @status = @external_user.status
    end

    def update_status
      Core::ExternalUser::StatusUpdaterService.new(
        params: params,
        current_user: current_user,
        external_user: @external_user
      ).update!
      respond_to do |format|
        format.js
        format.html {
          redirect_to action: :show, id: @external_user.id
        }
      end
    end

    def analyse_latest_posts
      Core::ExternalUser::LatestPostsAnalyserService.new(
        current_user: current_user,
        external_user: @external_user
      ).schedule_analysis!
      redirect_to action: :show, id: @external_user.id
    end

    private

    def find_external_user
      @external_user = Core::ExternalUser.find params[:id]
    end
  end
end
