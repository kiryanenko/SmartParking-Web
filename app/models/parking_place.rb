class ParkingPlace < ApplicationRecord
  belongs_to :sensor
  belongs_to :parking, counter_cache: true
  has_one :user, through: :parking
  has_many :parking_states, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :title, presence: true
  validates :place_id, uniqueness: { scope: :sensor }
  validates :title, format: { with: /\A[\w@"':№.,*()А-Яа-яёЁ]*\Z/ }

  scope :unset_changed, -> { where(changed_state: true).update_all(changed_state: false) }
  scope :find_for_user, ->(id, user) { joins(:parking).find_by!(id: id, parkings: {user: user}) }

  scope :find_by_place_id_and_user, ->(place_id, sensor, user) do
    joins(:parking).find_by!(place_id: place_id, sensor: sensor, parkings: {user: user})
  end

  scope :cancel_reservations, -> do
    where(booked: true).joins(:orders).where("orders.created_at + INTERVAL '1 second' * orders.booked_time < now()").
        order('orders.id DESC').limit(1).update_all(booked: false)
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
        parking_id: parking_id,
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

  def book(booking_time)
    update(booked: true)
    MQTTService.instance.book(self, booking_time)
  end
end
