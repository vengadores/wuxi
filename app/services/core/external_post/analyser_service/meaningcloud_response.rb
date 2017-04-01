module Core
  class ExternalPost
    class AnalyserService
      class MeaningcloudResponse
        def initialize(response)
          @response = response
        end

        # aka 200
        def ok?
          @response["status"]["msg"] == "OK"
        end

        def ok_for_reposting?
          if !ok?
            # meaningcloud response was not successful
            # therefore we do not rely on it
            return true
          end
          score_tag_allowed_for_reposting?
        end

        private

        def score_tag_allowed_for_reposting?
          # The possible values are the following:
          # P+: strong positive
          # P: positive
          # NEU: neutral
          # N: negative
          # N+: strong negative
          # NONE: without sentiment
          non_allowed_values = ["N", "N+"]
          score_tag = @response["score_tag"]
          non_allowed_values.include?(score_tag)
        end
      end
    end
  end
end
