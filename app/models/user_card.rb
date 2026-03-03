class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card
  has_many :stamps, dependent: :destroy

  validates :user_id, uniqueness: { scope: :card_id }

  private
end