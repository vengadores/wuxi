module Core
  class ExternalUser
    class StatusUpdaterService
      def initialize(params:, current_user:, external_user:)
        @params = params
        @current_user = current_user
        @external_user = external_user
      end

      def update!
        external_user_params = {
          status: @params[:commit]
        }
        if @params[:notes].present?
          external_user_params[:notes] = @params[:notes]
        end

        @external_user.update!(external_user_params)
        Core::Activity.create!(
          subject: @external_user,
          action: :external_user_status_update,
          whodunit_id: @current_user.id,
          predicate: external_user_params
        )
      end
    end
  end
end
