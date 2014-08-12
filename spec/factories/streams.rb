# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stream do
    caption "Lollapalooza en Chile"
    lat "-33.45654"
    lng "-70.661713"
    user

    factory :pending_stream do
      status :pending
    end

    factory :created_stream do
      status :created
    end

    factory :live_stream do
      status :live
    end

    factory :archived_stream do
      status :archived
    end
  end
end
