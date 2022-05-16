require 'rails_helper'

RSpec.describe Reaction, type: :model do

  describe "バリデーション" do
    let!(:from_user) { create(:user, :seq) }
    let!(:to_user) { create(:user, :seq) }
    let(:reaction) { build(:reaction, from_user: from_user, to_user: to_user, status: "like") }

    context "userが重複せず作成される場合" do
      it "バリデーションが通る" do
        expect(reaction).to be_valid
      end
    end

    context "組み合わせがすでに存在している場合" do
      it "バリデーションに引っかかる" do
        FactoryBot.create(:reaction, from_user: from_user, to_user: to_user, status: "dislike")
        expect(reaction).not_to be_valid
      end
    end

    context "statusを空にして作成される場合" do
      it "バリデーションに引っかかる" do
        reaction.status = ""
        expect(reaction).not_to be_valid
      end
    end
  end
end
