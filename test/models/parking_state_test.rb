require 'test_helper'

# При добавлении состояния идентичного последнему, запись не добавляется
class ParkingStateTest < ActiveSupport::TestCase
  test "the state identical last do not create" do
    last_state = parking_states(:last_state)
    assert_no_difference 'ParkingState.count' do
      ParkingState.set_state(last_state.parking_place, last_state.free)
    end
  end
end
