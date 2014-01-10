# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stream do
    caption "Lollapalooza en Chile"
    lat "-33.45654"
    lng "-70.661713"
    geo_reference "Parque O'higgins"
    association :user

    factory :pending_stream do
      status Stream::STATUSES.index(:pending)
    end

    factory :created_stream do
      status Stream::STATUSES.index(:created)
    end

    factory :live_stream do
      status Stream::STATUSES.index(:live)
    end

    factory :archived_stream do
      status Stream::STATUSES.index(:archived)
    end
  end
end
