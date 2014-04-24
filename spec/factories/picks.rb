# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pick do
    stream
    vj
    active false
    active_audio false
  end
end
