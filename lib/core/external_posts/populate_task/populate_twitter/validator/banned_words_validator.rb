require "core/external_posts/populate_task/populate_twitter/validator/base_validator"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Validator
          class BannedWordsValidator < BaseValidator
            attr_reader :unpermitted_word

            def permitted_words?
              @unpermitted_word = get_unpermitted_word
              unpermitted_word.blank?
            end

            private

            def get_unpermitted_word
              banned_words = ::Core::BannedWord.all
              banned_words.detect do |banned_word|
                matches?(banned_word)
              end
            end

            def matches?(banned_word)
              regexp = /#{banned_word.content}\z/i
              tweet.full_text.split(" ").any? do |word|
                regexp.match(
                  word.gsub(/\W/,'') # strip non alpha characters
                )
              end
            end
          end
        end
      end
    end
  end
end
