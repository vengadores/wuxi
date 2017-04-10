module Core
  class ExternalProvider
    class TwitterAuthorizationService
      def initialize(account_id:)
        @account_id = account_id
      end

      def authorize_url
        @request_token = twitter_consumer.get_request_token(
          oauth_callback: callback_uri
        )
        @request_token.authorize_url(oauth_callback: callback_uri)
      end

      def verify_oauth!(oauth_verification_options)
        @access_token = @request_token.get_access_token(
          oauth_verification_options
        )
        @twitter_user = twitter_client.user(
          @access_token.params[:screen_name]
        )
        self
      end

      def build_external_provider
        ExternalProvider.new(
          provider: :twitter,
          account_id: @account_id,
          uid: @twitter_user.id,
          info: @twitter_user.to_hash,
          credentials: {
            token: @access_token.token,
            secret: @access_token.secret
          }
        )
      end

      private

      def twitter_consumer
        OAuth::Consumer.new(
          Rails.application.secrets.twitter_speaker_key,
          Rails.application.secrets.twitter_speaker_secret,
          site: "https://api.twitter.com",
          scheme: :body
        )
      end

      def callback_uri
        Rails.application.routes.url_helpers.send(
          "admin_account_external_provider_registration_url",
          account_id: @account_id
        )
      end

      def twitter_client
        TwitterClientService.new(
          token: @access_token.token,
          secret: @access_token.secret
        ).twitter_client
      end
    end
  end
end
