class Coupon < ApplicationRecord
  belongs_to :user
  belongs_to :card

  before_create :generate_code
  before_create :set_expiration

  private

  def generate_code
    begin
      self.code = SecureRandom.uuid
    end while Coupon.exists?(code: self.code)
  end

  def set_expiration
    self.expires_at ||= 14.days.from_now
  end
end