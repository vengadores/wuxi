module Core
  class ExternalUser
    class LatestPostsAnalyserService
      THROTTLE = 3

      def initialize(current_user:, external_user:)
        @current_user = current_user
        @external_user = external_user
      end

      def schedule_analysis!
        external_posts.each do |external_post|
          #
          # update status so it doesnt get re-queued
          # in case user re-schedules
          external_post.update!(status: :analysed)
          ::ExternalPostAnalyserWorker.perform_async(
            external_post.id.to_s
          )
        end
        log_activity!
      end

      private

      def external_posts
        @external_user.posts
                      .latest
                      .with_status(:new)
                      .limit(THROTTLE)
      end

      def log_activity!
        Core::Activity.create!(
          subject: @external_user,
          action: :external_user_analysis_latest_posts,
          whodunit_id: @current_user.id,
          predicate: { posts_count: THROTTLE }
        )
      end
    end
  end
end
