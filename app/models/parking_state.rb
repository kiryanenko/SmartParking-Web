class ParkingState < ApplicationRecord
  belongs_to :parking_place

  def self.set_state(parking_place, free)
    changed_state = false
    last_status = where(parking_place: parking_place).last
    if last_status.nil? || last_status.free != free
      create parking_place: parking_place, free: free
      changed_state = true
    else
      last_status.update updated_at: Time.now
    end

    parking_place.free = free
    parking_place.connected = true
    parking_place.changed_state ||= changed_state
    parking_place.save
  end
end
