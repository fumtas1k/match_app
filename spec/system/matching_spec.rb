require 'rails_helper'

RSpec.describe "Matching", type: :system do

  describe "一覧画面" do
    let!(:user) { create(:user) }
    let!(:both_like_user) { create(:user, :seq) }
    let!(:like_user) { create(:user, :seq) }
    let!(:to_like_user) { create(:user, :seq) }
    let!(:dislike_user) { create(:user, :seq) }
    let!(:noreaction_user) { create(:user, :seq) }
    let!(:both_to_reaction) { create(:reaction, from_user: user, to_user: both_like_user, status: :like) }
    let!(:user_to_reaction) { create(:reaction, from_user: user, to_user: like_user, status: :like) }
    let!(:to_reaction) { create(:reaction, from_user: user, to_user: to_like_user, status: :like) }
    let!(:both_from_reaction) { create(:reaction, from_user: both_like_user, to_user: user, status: :like) }
    let!(:dislike_to_reaction) { create(:reaction, from_user: user, to_user: dislike_user, status: :dislike) }
    context "マッチングしているのが1人だけでmatchingの一覧画面を見た場合" do
      it "マッチングした人だけ表示される" do
        sign_in user
        visit matching_index_path
        expect(page).to have_content both_like_user.name
        [like_user, to_like_user, dislike_user, noreaction_user].each { expect(page).not_to have_content _1.name }
      end
    end
  end
end
