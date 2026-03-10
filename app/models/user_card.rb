class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card
  has_many :stamps, dependent: :destroy

  validates :user_id, uniqueness: { scope: :card_id }

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end