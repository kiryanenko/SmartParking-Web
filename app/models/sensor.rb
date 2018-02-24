class Sensor < ApplicationRecord
  self.primary_key = :id
  belongs_to :user

  def self.user_sensors(user)
    where(user: user).order(:id)
  end

  def get_day_start_time
    Time.at(day_start_time).utc
  end

  def get_night_start_time
    Time.at(night_start_time).utc
  end
end
