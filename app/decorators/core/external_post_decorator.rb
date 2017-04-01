module Core
  class ExternalPostDecorator < ::ApplicationDecorator
    decorates_association :external_user

    def to_s
      object.raw_hash["text"]
    end

    def external_link(options = {}, &block)
      uri = "https://twitter.com/#{external_user.screen_name}/status/#{uid}"
      h.link_to uri, options.merge(target: "_blank") do
        yield block
      end
    end
  end
end
