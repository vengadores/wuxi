module Core
  class ExternalProviderDecorator < ::ApplicationDecorator
    decorates_association :posts

    def latest_posts
      object.posts.latest.limit(50).decorate
    end
  end
end
