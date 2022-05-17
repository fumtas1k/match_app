class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    return if data["message"].blank?
    Message.create!(
      content: data["message"],
      user_id: current_user.id,
      chat_room_id: data["chat_room_id"]
    )
  end
end
