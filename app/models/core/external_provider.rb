module Core
  class ExternalProvider
    include Mongoid::Document

    SUPPORTED_PROVIDERS = {
      twitter: "https://twitter.com"
    }.with_indifferent_access.freeze
    PROVIDERS = SUPPORTED_PROVIDERS.keys.map(&:to_s).freeze

    belongs_to :account
    field :provider, type: String
    field :uid, type: String
    field :info, type: Hash
    field :credentials, type: Hash

    validate :provider_is_unique
    validates :account,
              :provider,
              :uid,
              presence: true

    def self.authorize(account_id, auth)
      create(
        uid: auth.uid,
        info: auth.info,
        provider: auth.provider,
        credentials: auth.credentials,
        account: Account.find(account_id)
      )
    end

    def external_uri
      case provider
      when "twitter"
        info["urls"]["Twitter"]
      end
    end

    def nickname
      case provider
      when "twitter"
        "@" + info["nickname"]
      end
    end

    private

    def provider_is_unique
      existing_scope = self.class.where(uid: uid, provider: provider)
      existing_scope = existing_scope.where(:id.ne => id) unless new_record?

      if existing_scope.exists?
        existing_provider = existing_scope.first
        errors.add(
          :base,
          "Ya está asociada a la cuenta #{existing_provider.account.name}"
        )
      end
    end
  end
end
