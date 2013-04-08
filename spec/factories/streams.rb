# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stream do
    id "ef18a7b75fc32246e46bd75ff910a582"
    url "http://url.com"
    title "Lollapalooza en Chile"
    desc "Excellent Music"
    lat "-33.45654"
    lng "-70.661713"
    geo_reference "Parque O'higgins"
    started_on "2013-04-08 11:25:35"
  end
end
