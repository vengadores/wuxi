FactoryGirl.define do
  factory :core_banned_word, class: 'Core::BannedWord' do
    sequence(:content) {|n| "WrongWord#{n}" }
  end
end
