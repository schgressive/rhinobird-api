# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stream_pool do
    stream
    user
    active false
  end
end
