module Speaker
  class TwitterSpeaker
    class TwitterSpeakingException
      def initialize(exception:, external_post:)
        @exception = exception
        @external_post = external_post
      end

      def handle!
        update_external_post_status!
        case @exception
        when Twitter::Error::Unauthorized
          if @exception.to_s =~ "You have been blocked"
            @external_post.external_user.update!(status: :blocked_us)
          else
            raise @exception
          end
        when Twitter::Error::Forbidden
          log_activity!
        else
          raise @exception
        end
      end

      private

      def update_external_post_status!
        @external_post.update!(status: :error_reposting)
      end

      def log_activity!
        Core::Activity.create!(
          subject: @external_post,
          action: :external_post_speaker_forbidden,
          predicate: { exception: @exception.to_s }
        )
      end
    end
  end
end
