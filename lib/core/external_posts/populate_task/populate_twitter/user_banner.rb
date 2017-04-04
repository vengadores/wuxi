module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class UserBanner
          def self.because_of_banned_words(external_user:, banned_word:)
            external_user.update!(status: :blacklist)
            Core::Activity.create!(
              subject: external_user,
              action: :blacklist_user_banned_word_usage,
              predicate: {
                word: banned_word.content
              }
            )
          end
        end
      end
    end
  end
end
