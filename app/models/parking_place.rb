class ParkingPlace < ApplicationRecord
  belongs_to :sensor
  belongs_to :parking

  validates :title, presence: true

  def self.find_for_user(id, user)
    find_by!(id: id, user: user)
  end
end
