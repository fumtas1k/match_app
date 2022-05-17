require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:chat_room) { create(:chat_room) }
    let(:message) { build(:message, user: user, chat_room: chat_room) }

    context "contentを入力した場合" do
      it "バリデーションが通る" do
        expect(message).to be_valid
      end
    end

    context "contentを空にした場合" do
      it "バリデーションに引っかかる" do
        message.content = ""
        expect(message).not_to be_valid
      end
    end
  end
end
