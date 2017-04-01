require "core/external_posts/populate_task/populate_twitter/validator/base_validator"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Validator
          class LanguageValidator < BaseValidator
            def allowed_language?
              return true if external_provider.account.rules.language.empty?
              external_provider.account.rules.language.all? do |rule|
                apply_language?(rule)
              end
            end

            private

            def apply_language?(rule)
              is_language = tweet.lang == rule.content
              is_language = is_language || tweet.metadata.iso_language_code == rule.content
              is_language = is_language || external_user.raw_hash["lang"] == rule.content
              return is_language == rule.allowed?
            end
          end
        end
      end
    end
  end
end
