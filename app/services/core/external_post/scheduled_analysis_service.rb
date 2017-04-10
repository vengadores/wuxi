module Core
  class ExternalPost
    class ScheduledAnalysisService
      class << self
        THROTTLE = 400

        def run!
          ##
          # let's sanitize languages
          grouped_analyses = scheduled_analyses.group_by(&:lang)
          sanitized_analyses = grouped_analyses.keys.inject({}) do |memo, lang|
            if Sentiment140Api::ALLOWED_LANGUAGES.include?(lang)
              memo[lang] = grouped_analyses[lang]
            else
              memo["auto"] ||= []
              memo["auto"].concat grouped_analyses[lang]
            end
            memo
          end
          sanitized_analyses.each do |language, analyses|
            new(language: language, analyses: analyses).run!
          end
        end

        def scheduled_analyses
          Brain::ScheduledAnalysis.latest
                                  .with_status(:new)
                                  .limit(THROTTLE)
        end
      end

      def initialize(language:, analyses:)
        puts "analysing #{analyses.count} posts in #{language}"
        @language = language
        @analyses = analyses
      end

      def run!
        # @external_posts = @analyses.map(&:subject)
        classification = post_to_sentiment_140
        Sentiment140Response.new(
          classification.response.body
        ).external_posts_response.each do |response|
          parse_external_post_response(response)
        end
      end

      private

      def parse_external_post_response(response)
        ##
        # may be better outside?
        analysis = Brain::ScheduledAnalysis.find response["id"]
        external_post = analysis.subject
        analysis.update!(status: :done)
        Brain::ExternalAnalysis.create!(
          subject_id: external_post.id,
          subject_type: "Core::ExternalPost",
          provider: :sentiment140,
          response: sanitize_post_response(response)
        )
        if response["polarity"] == 4 # AKA P+
          external_post.update!(status: :will_repost)
        end
      end

      def sanitize_post_response(response)
        response.slice("polarity", "meta")
      end

      def post_to_sentiment_140
        sentiment140_api = Sentiment140Api.new
        data = @analyses.map do |analysis|
          {
            id: analysis.id.to_s,
            text: get_text_for(analysis),
            query: get_query_for(analysis)
          }
        end
        sentiment140_api.classify_analyses(
          data: data,
          language: @language
        )
      end

      def get_text_for(analysis)
        analysis.subject.raw_hash["text"]
      end

      def get_query_for(analysis)
        Core::Account::SearchtermService.new(
          analysis.subject.external_provider.account
        ).rules_joined
      end
    end
  end
end
