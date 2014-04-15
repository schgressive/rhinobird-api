FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    name "Sirius Black"
    email { Faker::Internet.email }
    password "12345678"
    confirmed_at Time.now
    share_facebook true
    fb_token "ABC"
  end
end
