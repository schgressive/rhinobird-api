FactoryGirl.define do
  factory :user do
    name "Sirius Black"
    email { Faker::Internet.email }
    password "12345678"
    confirmed_at Time.now
  end
end
