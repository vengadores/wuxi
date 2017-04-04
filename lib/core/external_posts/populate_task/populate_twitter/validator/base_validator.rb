module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        class Validator
          class BaseValidator
            delegate :tweet,
                     :external_user,
                     :external_provider,
                     to: :@validator

            def initialize(validator:)
              @validator = validator
            end
          end
        end
      end
    end
  end
end
