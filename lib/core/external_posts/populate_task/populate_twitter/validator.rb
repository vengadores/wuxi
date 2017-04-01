require "core/external_posts/populate_task/populate_twitter/user_banner"
require "core/external_posts/populate_task/populate_twitter/validator/language_validator"
require "core/external_posts/populate_task/populate_twitter/validator/searchterm_validator"
require "core/external_posts/populate_task/populate_twitter/validator/banned_words_validator"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Validator
          attr_reader :tweet,
                      :external_user,
                      :external_provider

          def initialize(tweet:, external_user:, external_provider:)
            @tweet = tweet
            @external_user = external_user
            @external_provider = external_provider
          end

          def saveable?
            rules_apply?
          end

          private

          def rules_apply?
            permitted_user? && permitted_words? && any_searchterm? && allowed_language?
          end

          def permitted_user?
            !@external_user.status.blacklist?
          end

          def permitted_words?
            words_validator = BannedWordsValidator.new(validator: self)
            clean = words_validator.permitted_words?
            if !clean
              UserBanner.because_of_banned_words(
                external_user: @external_user,
                banned_word: words_validator.unpermitted_word
              )
            end
            clean
          end

          def any_searchterm?
            SearchtermValidator.new(validator: self).any_searchterm?
          end

          def allowed_language?
            LanguageValidator.new(validator: self).allowed_language?
          end
        end
      end
    end
  end
end
