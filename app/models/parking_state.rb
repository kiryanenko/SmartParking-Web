class ParkingState < ApplicationRecord
  belongs_to :parking_place

  def self.set_state(parking_place, free)
    if parking_place.free != free
      create parking_place: parking_place, free: free
      parking_place.changed_state = true
    else
      last_status = where(parking_place: parking_place).last
      last_status.update updated_at: Time.now
    end

    parking_place.free = free
    parking_place.connected = true
    parking_place.changed_state = true  # FIXME
    parking_place.save
  end
end
