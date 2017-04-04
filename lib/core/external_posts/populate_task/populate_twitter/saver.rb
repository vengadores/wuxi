require "core/external_posts/populate_task/populate_twitter/validator"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Saver
          def initialize(tweet:, external_provider:)
            @tweet = tweet
            @external_provider = external_provider
          end

          def save
            external_user.save if !external_user_exists?
            post.save if candidate_for_saving?
          end

          private

          def candidate_for_saving?
            Validator.new(
              tweet: @tweet,
              external_user: external_user,
              external_provider: @external_provider
            ).saveable?
          end

          def external_user_exists?
            external_user_scope.exists?
          end

          def external_user_scope
            ::Core::ExternalUser.where(
              uid: @tweet.user.id,
              provider: :twitter
            )
          end

          def external_user
            external_user_scope.first_or_initialize do |user|
              user.raw_hash = @tweet.user.to_hash
            end
          end

          def post
            ::Core::ExternalPost.new(
              external_user: external_user,
              external_provider: @external_provider,
              provider: :twitter,
              uid: @tweet.id,
              raw_hash: @tweet.to_hash
            )
          end
        end
      end
    end
  end
end
