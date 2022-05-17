require 'rails_helper'

RSpec.describe ChatRoomUser, type: :model do
  describe "バリデーション" do
    let!(:chat_room) { create(:chat_room) }
    let!(:user) { create(:user) }
    let!(:chat_room_user) { build(:chat_room_user, user: user, chat_room: chat_room) }

    context "存在しないchatroomとuseの組み合わせを作成しようとした場合" do
      it "バリデーションが通る" do
        expect(chat_room_user).to be_valid
      end
    end

    context "すでに存在するchatroomとuseの組み合わせを作成しようとした場合" do
      it "バリデーションに引っかかる" do
        FactoryBot.create(:chat_room_user, user: user, chat_room: chat_room)
        expect(chat_room_user).not_to be_valid
      end
    end
  end
end
