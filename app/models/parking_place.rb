class ParkingPlace < ApplicationRecord
  belongs_to :sensor
  belongs_to :parking
  has_one :user, through: :parking

  validates :title, presence: true
  validates :place_id, uniqueness: { scope: :sensor, message: I18n.t(:place_id_should_be_uniq) }

  scope :unset_changed, -> { where(changed_state: true).update_all(changed_state: false) }
  scope :find_for_user, ->(id, user) { joins(:parking).find_by!(id: id, parkings: {user: user}) }

  scope :find_by_place_id_and_user, ->(place_id, sensor, user) do
    joins(:parking).find_by!(place_id: place_id, sensor: sensor, parkings: {user: user})
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



  def response
    {
        id: id,
        parking: parking_id,
        title: title,
        coord: {lat: coord.x, lng: coord.y},
        for_disabled: for_disabled,
        booked: booked,
        free: free,
        connected: connected,
        can_book: can_book,
        changed_state: changed_state
    }
  end
end
