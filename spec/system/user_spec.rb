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

  describe "authenticate_user!" do
    let!(:user) { create(:user) }
    context "ログインせずにプロフィールページを表示しようとした場合" do
      it "ログインページにリダイレクトする" do
        visit user_path(user)
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログイン後プロフィールページを表示しようとした場合" do
      it "プロフィールページが表示される" do
        sign_in user
        visit user_path(user)
        expect(current_path).to eq user_path(user)
      end
    end
  end

  describe "プロフィールページ" do
    let!(:user) { create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    context "ログインして表示する場合" do
      it "プロフィールページが表示される" do
        expect(current_path).to eq user_path(user)
      end
    end

    context "ログアウトボタンを押す場合" do
      it "ログアウトしてトップページが表示される" do
        click_link(href: destroy_user_session_path)
        expect(current_path).to eq root_path
      end
    end

    context "編集ボタンを押す場合" do
      it "ユーザー編集ページが表示される" do
        click_link(href: edit_user_registration_path(user))
        expect(current_path).to eq edit_user_registration_path(user)
      end
    end
  end
end
