require 'rails_helper'

RSpec.describe Reaction, type: :system do
  describe "create Action" do
    let!(:current_user) { create(:user) }
    let!(:user) { create(:user, :seq) }
    let(:reaction_attr) { attributes_for(:reaction, from_user: current_user, to_user: user, status: "like") }

    context "reactionが存在しないでlikeボタンを押した場合" do
      before do
        sign_in current_user
        visit users_path
      end
      it "statusがlikeでデータが作成される" do
        expect{
          find("#like").click
          sleep 0.1
          reaction = Reaction.last
          reaction_attr.each {|key, val| expect(reaction.send(key)).to eq val }
        }.to change(Reaction, :count).by(1)
      end
    end

    context "すでにreactionが存在していてlikeボタンを押した場合" do
      before do
        FactoryBot.create(:reaction, from_user: current_user, to_user: user, status: "dislike")
        sign_in current_user
        visit users_path
      end
      it "statusがlikeに更新され、新たには作成されない" do
        expect{
          find("#like").click
          sleep 0.1
          reaction = Reaction.last
          reaction_attr.each {|key, val| expect(reaction.send(key)).to eq val }
        }.to change(Reaction, :count).by(0)
      end
    end
  end
end
