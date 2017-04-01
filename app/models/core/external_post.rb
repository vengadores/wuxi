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

    index({ provider: 1, uid: 1 }, { unique: true })
    index({ status: 1 })

    enumerize :status,
              in: [
                :new,
                :analysed,    # analysed by 3rd parties, may not be reposted
                :will_repost, # scheduled for repost
                :reposted
              ],
              default: :new,
              scope: true

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

    private

    def analyse!
      # unfortunately APIs have limited rates
      if external_user.permit_third_party_analysis?
        ::ExternalPostAnalyserWorker.perform_async(id)
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
