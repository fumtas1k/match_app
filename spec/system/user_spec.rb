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
        expect(current_path).to eq user_path(User.last)
      end
    end

    context "女性を選択した場合" do
      let(:user_attr) { attributes_for(:user, gender: "female")}
      it "女性でアカウント登録される" do
        expect(User.last.email).to eq user_attr[:email]
        expect(current_path).to eq user_path(User.last)
        expect(User.last.gender).to eq user_attr[:gender]
      end
    end
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
        expect(current_path).to eq user_path(User.last)
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

  describe "編集ページ" do
    let(:user_attr) { attributes_for(:user) }
    let!(:user) { create(:user, user_attr) }

    context "何も入力せずに更新ボタンを押した場合" do
      before do
        sign_in user
        visit edit_user_registration_path(user)
        click_on "commit"
        sleep 0.1
      end
      it "プロフィールページに移動し、user情報は変わらない" do
        user_attr.delete(:password)
        user_attr.delete(:password_confirmation)
        profile_image = user_attr.delete(:profile_image)
        user_attr.each {|key, val| expect(user.reload.send(key)).to eq val }
        expect(user.reload.profile_image.identifier).to eq profile_image.original_filename
        expect(current_path).to eq user_path(user)
      end
    end

    context "全てを変更して更新ボタンを押した場合" do
      let(:user_attr) { attributes_for(:user, name: "seconduser", email: "second@diver.com",
                                       password: "password2", password_confirmation: "password2",
                                       gender: "female", self_introduction: "I am a ...",
                                       profile_image: "#{Rails.root}/spec/fixtures/images/avatar.jpg") }
      before do
        sign_in user
        visit edit_user_registration_path(user)
        fill_in "user_email", with: user_attr[:email]
        fill_in "user_name", with: user_attr[:name]
        fill_in "user_self_introduction", with: user_attr[:self_introduction]
        attach_file "user_profile_image", user_attr[:profile_image], visible: false
        fill_in "user_password", with: user_attr[:password]
        fill_in "user_password_confirmation", with: user_attr[:password_confirmation]
        find("#luser-gender-#{user_attr[:gender]}").click
        click_on "commit"
        sleep 0.1
      end
      it "プロフィールページに移動し、user情報が変更される" do
        user_attr.delete(:password)
        user_attr.delete(:password_confirmation)
        profile_image = user_attr.delete(:profile_image)
        user_attr.each {|key, val| expect(user.reload.send(key)).to eq val }
        expect(user.reload.profile_image.identifier).to eq profile_image.split("/").last
        expect(current_path).to eq user_path(user)
      end
    end

    context "パスワードと確認用パスワードが違う場合" do
      before do
        user_attr[:password_confirmation] = "password1"
        sign_in user
        visit edit_user_registration_path(user)
        fill_in "user_password", with: user_attr[:password]
        fill_in "user_password_confirmation", with: user_attr[:password_confirmation]
        click_on "commit"
        sleep 0.1
      end
      it "ユーザーは変更されず、エラーメッセージが表示される" do
        user_attr.delete(:password)
        user_attr.delete(:password_confirmation)
        profile_image = user_attr.delete(:profile_image)
        user_attr.each {|key, val| expect(user.reload.send(key)).to eq val }
        expect(page).to have_content I18n.t("errors.messages.not_saved.one", resource: User.model_name.human)
        expect(user.reload.profile_image.identifier).to eq profile_image.original_filename
      end
    end
  end
end
