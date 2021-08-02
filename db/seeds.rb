# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a sample admin.
User.create! full_name: "Admin",
             email: "admin@example.com",
             password: "foobar",
             password_confirmation: "foobar",
             role_id: 0
             # activated: true,
             # activated_at: Time.zone.now

# Generate 2 supervisors.
2.times do |n|
  name = Faker::Name.name
  email = "supervisor-#{n+1}@example.com"
  password = "password"
  User.create! full_name: name,
               email: email,
               password: password,
               password_confirmation: password,
               role_id: 1
               # activated: true,
               # activated_at: Time.zone.now
end

# Generate 6 trainees.
6.times do |n|
  name = Faker::Name.name
  email = "trainee-#{n+1}@example.com"
  password = "password"
  User.create! full_name: name,
               email: email,
               password: password,
               password_confirmation: password
               # activated: true,
               # activated_at: Time.zone.now
end

# Generate some subjects
Subject.create! name: "SQL",
                description: "Learning SQL",
                duration: Time.current

Subject.create! name: "Ruby",
                description: "Learning Ruby",
                duration: Time.current

Subject.create! name: "Git",
                description: "Learning Git",
                duration: Time.current

Subject.create! name: "Rails",
                description: "Learning Rails",
                duration: Time.current

Subject.create! name: "Agile/Scrum",
                description: "Learning Agile/Scrum",
                duration: Time.current

Subject.create! name: "Project 1",
                description: "Doing Project 1",
                duration: Time.current

# Generate tasks for subjects.
subjects = Subject.all
2.times do |n|
  name = "Task-#{n+1}"
  description = Faker::Lorem.sentence word_count: 5
  subjects.each{|subject| subject.tasks.create! name: name,
                  description:description}
end

# Generate two courses.
Course.create! name: "Ruby",
               description: "Học về Ruby",
               start_time: Time.current,
               status: 0

Course.create! name: "Rails Tutorial",
               description: "Học về Rails",
               start_time: Time.current,
               status: 0

# Generate some subjects for courses
subjects_1 = Subject.take 3
course_1 = Course.first
subjects_1.each do |subj|
  course_1.course_subjects.create! subject_id: subj.id,
    duration: subj.duration
end

subjects_2 = Subject.take 6
course_2 = Course.second
subjects_2.each do |subj|
  course_2.course_subjects.create! subject_id: subj.id,
    duration: subj.duration
end

# Generate some tasks for subjects in courses
course_subjects = CourseSubject.all
course_subjects.each do |course_subject|
  subject = Subject.find_by id: course_subject.subject_id
  subject.tasks.each do |task|
    course_subject.course_subject_tasks.create! name: task.name,
      description: task.description
  end
end


# Generate some user_courses
id = [2, 5, 6, 7]
id.each do |id|
  UserCourse.create! user_id: id, course_id: 1
end
