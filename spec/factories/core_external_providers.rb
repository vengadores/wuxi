FactoryGirl.define do
  factory :core_external_provider,
          class: 'Core::ExternalProvider' do
    association :account, factory: :core_account

    uid { SecureRandom.hex }
    provider { Core::ExternalProvider::PROVIDERS.sample }
    info {
      { "urls" => {},
        "nickname" => "someusername" }
    }
    credentials {
      { "token" => SecureRandom.hex,
        "secret" => SecureRandom.hex }
    }
  end
end
