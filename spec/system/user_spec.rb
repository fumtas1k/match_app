require 'rails_helper'

RSpec.describe User, type: :system do
  describe "アカウント登録" do
    before do
      visit new_user_registration_path
      fill_in "user_email", with: user_attr[:email]
      fill_in "user_name", with: user_attr[:name]
      fill_in "user_password", with: user_attr[:password]
      find("#luser-gender-#{user_attr[:gender]}").click
      click_on "commit"
      sleep 0.1
    end

    context "必要事項を入力した場合" do
      let(:user_attr) { attributes_for(:user) }
      it "アカウント登録される" do
        expect(User.last.email).to eq user_attr[:email]
        expect(current_path).to eq root_path
      end
    end

    context "女性を選択した場合" do
      let(:user_attr) { attributes_for(:user, gender: "female")}
      it "女性でアカウント登録される" do
        expect(User.last.email).to eq user_attr[:email]
        expect(current_path).to eq root_path
        expect(User.last.gender).to eq user_attr[:gender]
      end
    end

    # context "パスワードと確認用パスワードが違う場合" do
    #   let(:user_attr) { attributes_for(:user, password_confirmation: "aaaaaa") }
    #   it "アカウント登録されない" do
    #     expect(User.last).to be_falsey
    #     expect(page).to have_content I18n.t("errors.messages.not_saved.one", resource: User.model_name.human)
    #   end
    # end
  end

  describe "ログイン機能" do
    let!(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in "user_email", with: user_attr[:email]
      fill_in "user_password", with: user_attr[:password]
      click_on "commit"
      sleep 0.2
    end

    context "登録されている情報を入力した場合" do
      let(:user_attr) { attributes_for(:user) }
      it "ログインできる" do
        expect(current_path).to eq root_path
      end
    end

    context "登録されていない情報を入力した場合" do
      let(:user_attr) { attributes_for(:user, :seq) }
      it "ログインできない" do
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
