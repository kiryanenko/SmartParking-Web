class Sensor < ApplicationRecord
  self.primary_key = :id
  belongs_to :user

  def self.user_sensors(user)
    where user: user
  end

  def get_day_start_time
    Time.gm day_start_time
  end

  def get_night_start_time
    Time.gm night_start_time
  end
end
