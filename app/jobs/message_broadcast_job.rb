class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    chat_room = ChatRoom.find(message.chat_room_id)
    broadcast(message, chat_room)
  end

  private

  def render_message(message, user, chat_room_user)
    ApplicationController.renderer.render(partial: "messages/message", locals: {message: message, current_user: user, chat_room_user: chat_room_user})
  end

  def broadcast(message, chat_room)
    users = chat_room.users
    2.times do |i|
      ChatRoomChannel.broadcast_to [chat_room, users[i]], {message: render_message(message, users[i], users[-i])}
    end
  end
end
