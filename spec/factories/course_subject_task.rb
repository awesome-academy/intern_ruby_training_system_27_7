FactoryBot.define do
  factory :course_subject_task do
    course_subject {course_subject}
    name {Faker::Educator.course_name}
    description {Faker::Lorem.paragraph}
  end
end
