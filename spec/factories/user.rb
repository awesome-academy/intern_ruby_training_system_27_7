FactoryBot.define do
  factory :user, aliases: [:trainee] do
    full_name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    password {"password"}
    password_confirmation {"password"}
    role_id {"trainee"}
  end
end
