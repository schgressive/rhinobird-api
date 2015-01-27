# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :follow do
    user
    association :followed_user, factory: user
  end
end
