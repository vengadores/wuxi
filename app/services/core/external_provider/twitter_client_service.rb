module Core
  class ExternalProvider
    class TwitterClientService
      class << self
        def from_external_provider(external_provider)
          new(
            token: external_provider.credentials["token"],
            secret: external_provider.credentials["secret"]
          )
        end
      end

      def initialize(token:, secret:)
        @token = token
        @secret = secret
      end

      def twitter_client
        ##
        # uses speaker credentials
        Twitter::REST::Client.new do |config|
          config.access_token = @token
          config.access_token_secret = @secret
          config.consumer_key = Rails.application.secrets.twitter_speaker_key
          config.consumer_secret = Rails.application.secrets.twitter_speaker_secret
        end
      end
    end
  end
end
