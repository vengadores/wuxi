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

    def with_link(&block)
      h.link_to h.admin_external_user_path(object) do
        yield
      end
    end

    def activity
      Core::Activity.where(
        subject_id: object.id,
        subject_type: object.class.name
      ).latest
    end

    def latest_posts
      object.posts.latest.limit(50)
    end
  end
end
