class Sensor < ApplicationRecord
  self.primary_key = :id
  belongs_to :user

  def self.user_sensors(user)
    where user: user
  end
end
