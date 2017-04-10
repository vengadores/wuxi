module Core
  class ExternalPost
    class ScheduledAnalysisService
      THROTTLE = 200

      def run!
        scheduled_analyses.group_by(&:lang).each do |lang, analyses|
          post_to_sentiment_140!(lang, analyses)
        end
      end

      private

      def post_to_sentiment_140!(lang, analyses)
        allowed_languages = %w(en es)
        unless allowed_languages.include?(lang)
          lang = "auto"
        end
        external_posts = analyses.map(&:subject)
        sentiment140_api = Sentiment140Api.new
        sentiment140_api.classify_external_posts(
          language: lang,
          external_posts: external_posts
        )
      end

      def scheduled_analyses
        Brain::ScheduledAnalysis.limit(THROTTLE)
      end
    end
  end
end
