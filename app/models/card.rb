class Card < ApplicationRecord
  belongs_to :customer
  has_many :user_cards, dependent: :destroy
  has_many :users, through: :user_cards

  validates :name, :uuid, presence: true
  validates :name,
            presence: { message: "Name can't be blank" },
            length: { minimum: 4, too_short: "must be at least %{count} characters" }
  validates :uuid, uniqueness: true
  validates :how_many, presence: true, numericality: { greater_than: 0 }

  before_validation :generate_uuid, on: :create

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end