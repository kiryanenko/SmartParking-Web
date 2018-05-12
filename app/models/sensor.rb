class Sensor < ApplicationRecord
  self.primary_key = :id
  belongs_to :user
  has_many :parking_places, dependent: :destroy

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_sensors, ->(user) { where(user: user).order(:id) }

  def get_day_start_time
    Time.at(day_start_time).utc
  end

  def get_night_start_time
    Time.at(night_start_time).utc
  end
end
