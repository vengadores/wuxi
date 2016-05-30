FactoryGirl.define do
  factory :core_rule, class: 'Core::Rule' do
    kind "MyString"
    content "MyString"
    allow false
  end
end
