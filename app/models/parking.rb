require 'rgeo'

class Parking < ApplicationRecord
  belongs_to :user
  has_many :parking_places

  before_validation :ensure_times_both_nil
  validates :title, :area, presence: true

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_parkings, ->(user) { where(user: user).order(:id) }

  scope :parkings_at_location, ->(coord, radius, params = {}) do
    res = where("ST_Intersects(ST_GeographyFromText('SRID=4326;POLYGON((? ?, ? ?, ? ?, ? ?, ? ?))'), area)",
          coord[:lat] - radius, coord[:lng] - radius,
          coord[:lat] - radius, coord[:lng] + radius,
          coord[:lat] + radius, coord[:lng] + radius,
          coord[:lat] + radius, coord[:lng] - radius,
          coord[:lat] - radius, coord[:lng] - radius
          )
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
        start_time: start_time,
        end_time: end_time
    }
  end
end
