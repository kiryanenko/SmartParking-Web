json.extract! parking_place, :id, :place_id, :sensor_id, :parking_id, :title, :coords, :for_disabled, :booked, :free, :connected, :can_book, :created_at, :updated_at
json.url parking_place_url(parking_place, format: :json)
