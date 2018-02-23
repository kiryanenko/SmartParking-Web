class Sensor < ApplicationRecord
  self.primary_key = :id
  belongs_to :user

  def user_sensors(user)
    find_by user: user
  end
end
