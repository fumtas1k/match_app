require 'rails_helper'

RSpec.describe ChatRoomUser, type: :system do
  describe "create" do
    let!(:current_user) { create(:user) }
    let!(:chat_user) { create(:user, :seq) }
    let!(:reaction1) { create(:reaction, to_user: current_user, from_user: chat_user, status: :like) }
    let!(:reaction2) { create(:reaction, to_user: chat_user, from_user: current_user, status: :like) }

    before do
      sign_in current_user
      visit matching_index_path
    end

    context "chat_roomがないchat_userをクリックした場合" do
      it "chat_roomが作成され表示される" do
        expect {
          click_on chat_user.name
          sleep 0.1
          expect(current_path).to eq user_chat_room_path(current_user, current_user.chat_rooms.last)
        }.to change(ChatRoom, :count).by(1)
      end
    end

    context "chat_userを2度目にクリックした場合" do
      before do
        click_on chat_user.name
        sleep 0.1
        visit matching_index_path
      end
      it "新規作成はされずchat_roomが表示される" do
        expect {
          click_on chat_user.name
          sleep 0.1
          expect(current_path).to eq user_chat_room_path(current_user, current_user.chat_rooms.last)
        }.to change(ChatRoom, :count).by(0)
      end
    end
  end
end
