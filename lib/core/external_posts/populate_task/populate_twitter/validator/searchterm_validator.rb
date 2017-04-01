require "core/external_posts/populate_task/populate_twitter/validator/base_validator"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Validator
          class SearchtermValidator < BaseValidator
            def any_searchterm?
              any_allowed_searchterm? && !any_non_allowed_searchterms?
            end

            private

            def any_allowed_searchterm?
              searchterms.allowed.any? do |rule|
                apply_searchterm?(rule)
              end
            end

            def any_non_allowed_searchterms?
              searchterms.non_allowed.any? do |rule|
                apply_searchterm?(rule)
              end
            end

            def searchterms
              external_provider.account.rules.searchterm
            end

            def apply_searchterm?(rule)
              options = nil
              if !rule.case_sensitive?
                options = Regexp::IGNORECASE
              end
              rule_regexp = Regexp.new(rule.content, options)
              matches = rule_regexp.match(tweet.full_text)
              if rule.can_mention? || !rule.allowed?
                # no further analysis for non-allowed
                # searchterms or terms supporting mentions
                return matches
              end
              is_mention = tweet.full_text.split(" ").any? do |word|
                word.include?("@") && rule_regexp.match(word)
              end
              return matches && !is_mention
            end
          end
        end
      end
    end
  end
end
