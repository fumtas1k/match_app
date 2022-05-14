require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    let(:user) { build(:user) }
    shared_examples "バリデーションに引っかかる" do
      it { expect(user).not_to be_valid }
    end

    context "必須事項を全て入力した場合" do
      it "バリデーションが通る" do
        expect(user).to be_valid
      end
    end

    context "emailを空白にした場合" do
      before { user.email = "" }
      it_behaves_like "バリデーションに引っかかる"
    end

    context "emailに@がない場合" do
      before { user.email.sub!("@", "") }
      it_behaves_like "バリデーションに引っかかる"
    end

    context "nameを空白にした場合" do
      before { user.name = "" }
      it_behaves_like "バリデーションに引っかかる"
    end

    context "nameを20文字にした場合" do
      before { user.name = "a" * 20 }
      it "バリデーションが通る" do
        expect(user).to be_valid
      end
    end

    context "nameを21文字にした場合" do
      before { user.name = "a" * 21 }
      it_behaves_like "バリデーションに引っかかる"
    end

    context "passwordを6文字にした場合" do
      before do
        user.password = "a" * 6
        user.password_confirmation = "a" * 6
      end
      it "バリデーションが通る" do
        expect(user).to be_valid
      end
    end

    context "passwordを5文字にした場合" do
      before do
        user.password = "a" * 5
        user.password_confirmation = "a" * 5
      end
      it_behaves_like "バリデーションに引っかかる"
    end

    context "passwordとpassword_confirmationが異なる場合" do
      before { user.password_confirmation = "a" * 6 }
      it_behaves_like "バリデーションに引っかかる"
    end

    context "紹介文を500文字にした場合" do
      before { user.self_introduction = "a" * 500 }
      it "バリデーションが通る" do
        expect(user).to be_valid
      end
    end

    context "紹介文を501文字にした場合" do
      before { user.self_introduction = "a" * 501 }
      it_behaves_like "バリデーションに引っかかる"
    end
  end
end
