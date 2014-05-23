# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline do
    resource_id 1
    resource_type "MyString"
    user_id 1
  end
end
