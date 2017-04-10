module Core
  class ExternalPost
    class ScheduledAnalysisService
      class Sentiment140Response
        def initialize(body)
          @body = body
        end

        def external_posts_response
          JSON.parse(@body)["data"]
        end
      end
    end
  end
end
