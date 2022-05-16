FactoryBot.define do
  factory :reaction do
    association :to_user, factory: :user
    association :from_user, factory: :user
    status { "like" }
  end
end
