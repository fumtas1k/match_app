class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user_chat_room_ids = ChatRoomUser.where(user_id: current_user.id).pluck(:chat_room_id)
    chat_room = ChatRoomUser.where(chat_room_id: current_user_chat_room_ids, user_id: params[:user_id]).map(&:chat_room).first
    if chat_room.blank?
      chat_room = ChatRoom.create
      chat_room.chat_room_users.create(user_id: current_user.id)
      chat_room.chat_room_users.create(user_id: params[:user_id])
    end
    redirect_to chat_room
  end

  def show; end
end