class Admin::User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :trackable,
         :omniauthable, omniauth_providers: [:twitter]

  field :nickname
  field :info, type: Hash
  field :credentials, type: Hash

  ## omniauthable
  field :provider
  field :uid

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  alias_method :to_s, :nickname

  def self.from_omniauth(auth)
    where(
      uid: auth.uid,
      provider: auth.provider
    ).first_or_create.tap do |user|
      user.nickname = auth.info.nickname
      user.info = auth.info
      user.credentials = auth.credentials
      user.save!
    end
  end
end
