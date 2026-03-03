class Stamp < ApplicationRecord
  belongs_to :user_card

  validates :scan_token, presence: true, uniqueness: true
end