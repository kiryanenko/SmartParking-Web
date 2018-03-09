require 'rgeo'

class Parking < ApplicationRecord
  belongs_to :user
  has_many :parking_places

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }

  before_validation :ensure_times_both_nil
  validates :title, :area, presence: true

  def self.user_parkings(user)
    where(user: user).order(:id)
  end

  def ensure_times_both_nil
    if start_time.nil? or end_time.nil?
      self.start_time = nil
      self.end_time = nil
    end
  end

  def self.unset_changed

  end
end
