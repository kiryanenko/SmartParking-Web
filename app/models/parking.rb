require 'rgeo'

class Parking < ApplicationRecord
  belongs_to :user
  has_many :parking_places, dependent: :destroy

  before_validation :ensure_times_both_nil
  validates :title, :area, presence: true
  validates :title, :description, format: {
      with: /\A[\w @"':№.,«»*()А-Яа-яёЁ\/-]*\Z/
  }

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_parkings, ->(user) { where(user: user).order(:id) }

  scope :parkings_at_location, ->(coord, radius, cost = -1, params = {}) do
    res = where("ST_Intersects(ST_GeographyFromText('SRID=4326;POLYGON((
                :area_lat1 :area_lng1,
                :area_lat2 :area_lng2,
                :area_lat3 :area_lng3,
                :area_lat4 :area_lng4,
                :area_lat1 :area_lng1))'), parkings.area)",
              area_lat1: coord[:lat] - radius, area_lng1: coord[:lng] - radius,
              area_lat2: coord[:lat] - radius, area_lng2: coord[:lng] + radius,
              area_lat3: coord[:lat] + radius, area_lng3: coord[:lng] + radius,
              area_lat4: coord[:lat] + radius, area_lng4: coord[:lng] - radius,
    )
    res = res.where('cost <= ?', cost) if cost > -1
    res = res.joins(:parking_places).where(parking_places: params).distinct if params.any?
    res
  end

  def ensure_times_both_nil
    if start_time.nil? or end_time.nil?
      self.start_time = nil
      self.end_time = nil
    end
  end

  def response
    {
        id: id,
        title: title,
        description: description,
        cost: cost,
        area: area.coordinates.first.map { |coord| {lat: coord.first, lng: coord.last} },
        start_time: start_time.nil? ? nil : start_time.strftime("%R"),
        end_time: end_time.nil? ? nil : end_time.strftime("%R"),
        places_count: parking_places_count,
    }
  end

  def self.response_parkings_at_location(coord, radius, cost = 0, params = {})
    parkings_at_location(coord, radius, cost, params).map do |parking|
      res = parking.response
      places = parking.parking_places.where(params)
      res[:parking_places] = places.map { |place| place.response }
      res[:selected_places_count] = places.size
      res
    end
  end
end
