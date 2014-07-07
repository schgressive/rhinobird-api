# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vj do
    user
    channel
    status :created
  end
end
