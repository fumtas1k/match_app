class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    user = User.find(params[:user_id])
    # stream_from "chat_room_channel_#{user_id}_#{chat_room_id}"
    stream_for [chat_room, user]
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
