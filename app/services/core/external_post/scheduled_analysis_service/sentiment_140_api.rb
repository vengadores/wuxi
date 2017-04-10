module Core
  class ExternalPost
    class ScheduledAnalysisService
      class Sentiment140Api
        include HTTParty
        base_uri "http://www.sentiment140.com/api"
        debug_output

        def classify_external_posts(language:, external_posts:)
          data = external_posts.map do |external_post|
            query = Core::Account::SearchtermService.new(
              external_post.external_provider.account
            ).rules_joined
            {
              id: external_post.id,
              text: external_post.raw_hash["text"],
              query: query
            }
          end
          body = {
            data: data,
            language: language
          }
          self.class.post(
            "/bulkClassifyJson?#{app_id}",
            body.to_json
          )
        end

        private

        def app_id
          client_email = Rails.application.secrets.sentiment140_email
          "appid=#{client_email}"
        end
