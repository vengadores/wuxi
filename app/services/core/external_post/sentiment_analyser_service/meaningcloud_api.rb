module Core
  class ExternalPost
    class SentimentAnalyserService
      class MeaningcloudApi
        include HTTParty
        base_uri "https://api.meaningcloud.com"
        debug_output

        def sentiment(text:, lang:)
          self.class.post(
            "/sentiment-2.1",
            body: {
              key: token,
              lang: lang,
              txt: text,
              verbose: "y"
            }
          )
        end

        private

        def token
          Rails.application.secrets.meaningcloud_token.presence || fail("please define bitext token!")
        end
      end
    end
  end
end
