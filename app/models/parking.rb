class Parking < ApplicationRecord
  belongs_to :user

  before_validation :ensure_times_both_nil
  validates :title, presence: true

  def self.user_parkings(user)
    where(user: user).order(:id)
  end

  private
  def ensure_times_both_nil
    if start_time.nil? or end_time.nil?
      self.start_time = nil
      self.end_time = nil
    end
  end
end
