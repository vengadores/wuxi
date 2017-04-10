module Core
  class ExternalUser
    class ThrottlerService
      MINUTES_WINDOW = 5
      MAX_PER_WINDOW = 3

      def initialize(external_user:)
        @external_user = external_user
      end

      def allow_more?
        time_ago = MINUTES_WINDOW.minutes.ago
        exceeded = @external_user.posts.since(time_ago).count >= MAX_PER_WINDOW
        if exceeded
          create_activity! if @log_activity
          set_user_as_throttled! if @update_user_status
        end
        !exceeded
      end

      def log_activity!
        @log_activity = true
        self
      end

      def update_user_status!
        @update_user_status = true
        self
      end

      private

      def create_activity!
        Core::Activity.create!(
          subject: @external_user,
          action: :external_user_exceeded_throttle,
          predicate: {
            count: @external_user.posts.since(time_ago).count,
            desc: "posts in last #{minutes_window} minutes. since #{time_ago}"
          }
        )
      end

      def set_user_as_throttled!
        old_status = @external_user.status
        ::ExternalUserThrottlerUnlockerWorker.perform_in(
          MINUTES_WINDOW.minutes,
          @external_user.id.to_s,
          old_status
        )
        @external_user.update!(
          status: :throttled_by_quota
        )
      end
    end
  end
end
