FactoryBot.define do
  srand(1234)
  factory :user do
    name { "firstuser" }
    email { "first@diver.com" }
    gender { "male" }
    password { "password" }
    password_confirmation { "password" }
    self_introduction { "I am a genius" }
    profile_image { fixture_file_upload("#{::Rails.root}/spec/fixtures/images/dummy_user.jpg") }
    trait :seq do
      sequence :name, "user001"
      sequence :email, "user001@diver.com"
      gender { User.genders.keys[rand(2)] }
    end
  end
end
