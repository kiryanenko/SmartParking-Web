class ParkingPlace < ApplicationRecord
  belongs_to :sensor
  belongs_to :parking
  has_one :user, through: :parking

  validates :title, presence: true

  scope :unset_changed, -> { where(changed_state: true).update_all(changed_state: false) }

  scope :find_for_user, ->(id, user) do
    place = find(id)
    raise ActiveRecord::RecordNotFound unless place.user == user
    place
  end

  scope :parking_places_at_location, ->(coord, radius, params = {}) do
    where("ST_Intersects(ST_GeographyFromText('SRID=4326;POLYGON((? ?, ? ?, ? ?, ? ?, ? ?))'), coord)",
          coord[:lat] - radius, coord[:lng] - radius,
          coord[:lat] - radius, coord[:lng] + radius,
          coord[:lat] + radius, coord[:lng] + radius,
          coord[:lat] + radius, coord[:lng] - radius,
          coord[:lat] - radius, coord[:lng] - radius
    ).where(params)
  end
end
