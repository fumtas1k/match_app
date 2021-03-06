class Reaction < ApplicationRecord
  belongs_to :to_user, foreign_key: :to_user_id, class_name: "User"
  belongs_to :from_user, foreign_key: :from_user_id, class_name: "User"

  enum status: {like: 0, dislike: 1}

  validates_uniqueness_of :to_user_id, scope: :from_user_id
  validates :status, presence: true
end
