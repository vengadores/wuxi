module Core
  class ExternalPost
    class AnalyserService
      def initialize(external_post)
        @external_post = external_post
      end

      def analyse!
        analysis_answers = [
          perform_sentiment_analysis!
        ]
        @external_post.update!(status: :analysed)
        if analysis_answers.all?
          schedule_reposting!
        end
      end

      private

      def schedule_reposting!
        # reposting handled by the speaker
        @external_post.update!(status: :will_repost)
      end

      def perform_sentiment_analysis!
        analysers_answers = [
          analyse_with_bitext!,
          analyse_with_meaningcloud!
        ]
        analysers_answers.all?
      end

      def analyse_with_bitext!
        bitext_api = BitextApi.new
        post_response = bitext_api.post_sentiment(
          text: @external_post.raw_hash["text"],
          our_language: @external_post.raw_hash["lang"]
        )
        unless post_response.response.is_a?(Net::HTTPServiceUnavailable)
          fail "working? TODO"
        end
        true # yeah
      end

      def analyse_with_meaningcloud!
        meaningcloud_api = MeaningcloudApi.new
        response = meaningcloud_api.sentiment(
          text: @external_post.raw_hash["text"],
          lang: @external_post.raw_hash["lang"]
        )
        meaningcloud = MeaningcloudResponse.new(response.parsed_response)
        if meaningcloud.ok?
          Brain::ExternalAnalysis.create!(
            subject: @external_post,
            provider: :meaningcloud,
            response: response
          )
        end
        meaningcloud.ok_for_reposting?
      end
    end
  end
end
