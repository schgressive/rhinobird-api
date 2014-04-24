# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :channel do
    name { Faker::Internet.domain_word }
  end
end
