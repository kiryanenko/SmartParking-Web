class ParkingPlace < ApplicationRecord
  belongs_to :sensor
  belongs_to :parking
  has_one :user, through: :parking

  validates :title, presence: true

  def self.find_for_user(id, user)
    place = find(id)
    raise ActiveRecord::RecordNotFound unless place.user == user
    place
  end
end
