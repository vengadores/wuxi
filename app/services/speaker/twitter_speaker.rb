module Speaker
  class TwitterSpeaker
    class << self
      THROTTLE = 1

      def speak!
        Core::ExternalProvider.active
                              .repost
                              .with_provider(:twitter)
                              .each do |external_provider|
            scope = external_provider.posts
                                     .latest
                                     .with_status(:will_repost)
            scope.limit(THROTTLE).each do |external_post|
              new(external_post).speak!
            end
        end
      end
    end

    def initialize(external_post)
      @external_post = external_post
    end

    def speak!
      retweet!
      @external_post.update!(status: :reposted)
    end

    private

    def retweet!
      twitter_client.retweet!(
        Twitter::Tweet.new(
          @external_post.raw_hash.with_indifferent_access
        )
      )
    rescue Exception => e
      TwitterSpeakingException.new(
        exception: e,
        external_post: @external_post
      ).handle!
    end

    def twitter_client
      Core::ExternalProvider::TwitterClientService.from_external_provider(
        @external_post.external_provider
      ).twitter_client
    end
  end
end
