module Core
  class ExternalUserDecorator < ::ApplicationDecorator
    def nickname
      "@" + screen_name
    end

    def screen_name
      raw_hash["screen_name"]
    end

    def name
      raw_hash["name"]
    end

    def image
      raw_hash["profile_image_url"]
    end

    def nickname_with_link
      h.link_to nickname, "https://twitter.com/#{screen_name}", target: "_blank"
    end

    def activity
      Core::Activity.where(
        subject_id: object.id,
        subject_type: object.class.name
      )
    end
  end
end
