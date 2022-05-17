FactoryBot.define do
  factory :message do
    association :user, :seq
    association :chat_room
    content { "Hello World!" }
  end
end
