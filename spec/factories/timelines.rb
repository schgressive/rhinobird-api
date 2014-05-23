# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline do
    association :resource, factory: :stream
    user
  end
end
