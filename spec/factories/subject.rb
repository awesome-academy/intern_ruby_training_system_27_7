FactoryBot.define do
  factory :subject do
    name {Faker::Name.name}
    duration {Time.current}
    description {Faker::Lorem.sentence(word_count: 5)}
  end
end
