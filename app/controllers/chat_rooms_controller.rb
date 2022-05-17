class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user_chat_room_ids = ChatRoomUser.where(user_id: current_user.id).pluck(:chat_room_id)
    chat_room = ChatRoomUser.find_by(chat_room_id: current_user_chat_room_ids, user_id: params[:user_id])&.chat_room
    if chat_room.blank?
      chat_room = ChatRoom.create
      chat_room.chat_room_users.create(user_id: current_user.id)
      chat_room.chat_room_users.create(user_id: params[:user_id])
    end
    redirect_to user_chat_room_path(current_user, chat_room)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @chat_room_user = @chat_room.chat_room_users.find_by(user_id: current_user.id)&.user
    @messages = Message.where(chat_room_id: @chat_room.id).order(:created_at)
  end
end
