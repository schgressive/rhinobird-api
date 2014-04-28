# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    vj
    stream
    start_time { Time.now }
    duration 30
  end
end
