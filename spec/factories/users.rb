FactoryBot.define do
  factory :user do
    email { "first@diver.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :seq do
      sequence :email, "user001@diver.com"
    end
  end

end
