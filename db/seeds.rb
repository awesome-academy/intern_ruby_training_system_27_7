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
  subjects.each {|subject| subject.tasks.create! name: name,
                  description:description}
end
