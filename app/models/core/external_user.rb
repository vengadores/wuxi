module Core
  class ExternalUser
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :uid, type: String
    field :provider, type: String
    field :raw_hash, type: Hash
    field :status, type: String
    field :notes, type: String

    index({ provider: 1, uid: 1 }, { unique: true })
    index({ status: 1 })

    enumerize :status,
              in: [
                :new,
                :whitelist,
                :blacklist,
                :throttled_by_quota # aka 2 many posts
              ],
              default: :new,
              scope: true

    has_many :posts,
             class_name: "Core::ExternalPost"

    validates :provider,
              presence: true,
              inclusion: { in: ExternalProvider::PROVIDERS }
    validates :uid,
              :raw_hash,
              presence: true
    validate :uid_is_unique, on: :create

    def throttler_allow_more?
      ThrottlerService.new(external_user: self)
                      .log_activity!
                      .update_user_status!
                      .allow_more?
    end

    private

    def uid_is_unique
      scope = self.class.where(uid: uid, provider: provider)
      if scope.exists?
        errors.add(:uid, :already_taken)
      end
    end
  end
end
