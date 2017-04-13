module Core
  class ExternalPost
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :uid, type: String
    field :provider, type: String
    field :raw_hash, type: Hash
    field :external_created_at, type: Time
    field :status, type: String
    field :manually_reposted, type: Boolean, default: false

    index({ provider: 1, uid: 1 }, { unique: true })
    index({ status: 1 })
    index({ external_created_at: 1 })

    enumerize :status,
              in: [
                :new,
                :analysed,    # analysed by 3rd parties, may not be reposted
                :will_repost, # scheduled for repost
                :reposted,
                :error_reposting,
                :halted_by_user_throttler
              ],
              default: :new,
              scope: true,
              i18n_scope: "external_post.status"

    belongs_to :external_provider,
               class_name: "Core::ExternalProvider"
    belongs_to :external_user,
               class_name: "Core::ExternalUser"

    validates :provider,
              presence: true,
              inclusion: { in: ExternalProvider::PROVIDERS }
    validates :uid,
              :external_provider,
              :external_user,
              :raw_hash,
              presence: true
    validate :uid_is_unique, on: :create
    before_create :delete_external_user_from_hash
    before_create :set_external_created_at
    after_create :analyse!

    scope :latest, -> { order(external_created_at: :desc) }
    scope :for_provider, ->(provider) {
      where(provider: provider)
    }
    scope :since, ->(time_ago) {
      where(:"external_created_at.gte" => time_ago)
    }

    private

    def analyse!
      # do nothing if user in blacklist
      return if external_user.status.blacklist?
      # unfortunately APIs have limited rates
      if external_user.throttler_allow_more?
        ::ExternalPostAnalyserWorker.perform_async(id.to_s)
      else
        update!(status: :halted_by_user_throttler)
      end
    end

    def uid_is_unique
      scope = self.class.where(uid: uid, provider: provider)
      if scope.exists?
        errors.add(:uid, :already_taken)
      end
    end

    def set_external_created_at
      self.external_created_at = raw_hash[:created_at]
    end

    def delete_external_user_from_hash
      if external_user.present?
        self.raw_hash["user"] = { wuxi_status: :truncated }
      end
    end
  end
end
