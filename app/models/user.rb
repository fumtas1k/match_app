class User < ApplicationRecord
  has_many :active_reactions, foreign_key: :from_user_id, class_name: "Reaction", dependent: :destroy
  has_many :passive_reactions, foreign_key: :to_user_id, class_name: "Reaction", dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users, source: :chat_room
  has_many :messages, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :name, presence: true, length: { maximum: 20 }
  validates :self_introduction, length: { maximum: 500 }

  enum gender: {male: 0, female: 1}

  mount_uploader :profile_image, ProfileImageUploader

  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def self.guest
    email = "guest@diver.com"
    find_or_create_by!(email: email) do |user|
      user.name = "Guest"
      user.email = email
      user.gender = :female
      user.password = "password"
      user.self_introduction = "私はゲストです。"
      user.profile_image = File.open("#{Rails.root}/db/dummy_images/avatar.jpg")
    end
  end
end
