FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    name "Sirius Black"
    email { Faker::Internet.email }
    password "12345678"
    authentication_token { Devise.friendly_token }
    confirmed_at Time.now
    share_facebook false
    share_twitter false
    fb_token "ABC"
  end
end
