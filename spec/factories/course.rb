FactoryBot.define do
  factory :course do
    name {Faker::Educator.course_name}
    description {Faker::Lorem.paragraph}
    start_time {Time.current}
  end
end
