FactoryBot.define do
  factory :reaction do
    to_user { nil }
    from_user { nil }
    status { 1 }
  end
end
