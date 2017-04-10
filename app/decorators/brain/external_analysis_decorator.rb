module Brain
  class ExternalAnalysisDecorator < ::ApplicationDecorator
    SENTIMENT140_SCORES = {
      "0" => "N-",
      "2" => "NEU",
      "4" => "P+"
    }.freeze

    def score
      case provider
      when "sentiment140"
        SENTIMENT140_SCORES.fetch(response["polarity"].to_s)
      when "meaningcloud"
        response["score_tag"]
      end
    end
  end
end
