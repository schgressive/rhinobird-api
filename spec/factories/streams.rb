# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stream do
    caption "Lollapalooza en Chile"
    lat "-33.45654"
    lng "-70.661713"
    geo_reference "Parque O'higgins"
    association :user
  end
end
