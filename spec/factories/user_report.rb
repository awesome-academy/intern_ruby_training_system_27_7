FactoryBot.define do
  factory :user_report do
    user {trainee}
    course {course}
    content {Faker::Lorem.paragraph}
    date {Time.now}
  end
end
