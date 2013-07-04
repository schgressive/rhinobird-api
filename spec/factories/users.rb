FactoryGirl.define do
  factory :user do
    name "Sirius Black"
    email "sirius@peepol.tv"
    password "12345678"
    confirmed_at Time.now
  end
end
