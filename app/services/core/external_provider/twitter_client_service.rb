module Core
  class ExternalProvider
    class TwitterClientService
      def initialize(external_provider)
        @external_provider = external_provider
      end

      def twitter_client
        Twitter::REST::Client.new do |config|
          config.consumer_key = Rails.application.secrets.twitter_speaker_key
          config.consumer_secret = Rails.application.secrets.twitter_speaker_secret
          config.access_token = @external_provider.credentials["token"]
          config.access_token_secret = @external_provider.credentials["secret"]
        end
      end
    end
  end
end
