module Core
  class ExternalPost
    class ScheduledAnalysisService
      class Sentiment140Api
        include HTTParty
        base_uri "http://www.sentiment140.com/api"
        debug_output if Rails.env.development?

        ALLOWED_LANGUAGES = %w(en es).freeze

        def classify_analyses(data:, language:)
          body = {
            data: data,
            language: sanitize_language(language)
          }
          self.class.post(
            "/bulkClassifyJson?#{app_id}",
            body: body.to_json
          )
        end

        private

        def sanitize_language(lang)
          unless ALLOWED_LANGUAGES.include?(lang)
            return "auto"
          end
          lang
        end

        def app_id
          client_email = Rails.application.secrets.sentiment140_email
          "appid=#{client_email}"
        end
      end
    end
  end
end
