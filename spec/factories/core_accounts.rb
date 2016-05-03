FactoryGirl.define do
  factory :core_account,
          class: 'Core::Account' do
    sequence(:name) do |i|
      "CoreAccount #{i}"
    end
  end
end
