module Core
  class ExternalPostDecorator < ::ApplicationDecorator
    decorates_association :external_user

    def to_s
      object.raw_hash["text"]
    end

    def language
      object.raw_hash["lang"]
    end

    def external_link(options = {}, &block)
      uri = "https://twitter.com/#{external_user.screen_name}/status/#{uid}"
      h.link_to uri, options.merge(target: "_blank") do
        yield block
      end
    end

    def may_include_analysis?
      !object.status.new? && !object.status.halted_by_user_throttler?
    end

    def external_analyses
      @external_analyses ||= Brain::ExternalAnalysis.where(
        subject_id: object.id,
        subject_type: object.class.name
      )
    end
  end
end
