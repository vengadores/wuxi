module Speaker
  class TwitterSpeaker
    class << self
      THROTTLE = 1

      def speak!
        scope = Core::ExternalPost.latest
                                  .for_provider(:twitter)
                                  .with_status(:will_repost)
        scope.limit(THROTTLE).each do |external_post|
          new(external_post).speak!
        end
      end
    end

    def initialize(external_post)
      @external_post = external_post
    end

    def speak!
      return if !@external_post.external_provider.repost
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
    end

    def twitter_client
      Core::ExternalProvider::TwitterClientService.from_external_provider(
        @external_post.external_provider
      ).twitter_client
    end
  end
end
