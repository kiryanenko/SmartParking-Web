require "application_system_test_case"

class ParkingPlacesTest < ApplicationSystemTestCase
  setup do
    @parking_place = parking_places(:one)
  end

  test "visiting the index" do
    visit parking_places_url
    assert_selector "h1", text: "Parking Places"
  end

  test "creating a Parking place" do
    visit parking_places_url
    click_on "New Parking Place"

    fill_in "Booked", with: @parking_place.booked
    fill_in "Can Book", with: @parking_place.can_book
    fill_in "Connected", with: @parking_place.connected
    fill_in "Coords", with: @parking_place.coords
    fill_in "For Disabled", with: @parking_place.for_disabled
    fill_in "Free", with: @parking_place.free
    fill_in "Parking", with: @parking_place.parking_id
    fill_in "Place", with: @parking_place.place_id
    fill_in "Sensor", with: @parking_place.sensor_id
    fill_in "Title", with: @parking_place.title
    click_on "Create Parking place"

    assert_text "Parking place was successfully created"
    click_on "Back"
  end

  test "updating a Parking place" do
    visit parking_places_url
    click_on "Edit", match: :first

    fill_in "Booked", with: @parking_place.booked
    fill_in "Can Book", with: @parking_place.can_book
    fill_in "Connected", with: @parking_place.connected
    fill_in "Coords", with: @parking_place.coords
    fill_in "For Disabled", with: @parking_place.for_disabled
    fill_in "Free", with: @parking_place.free
    fill_in "Parking", with: @parking_place.parking_id
    fill_in "Place", with: @parking_place.place_id
    fill_in "Sensor", with: @parking_place.sensor_id
    fill_in "Title", with: @parking_place.title
    click_on "Update Parking place"

    assert_text "Parking place was successfully updated"
    click_on "Back"
  end

  test "destroying a Parking place" do
    visit parking_places_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Parking place was successfully destroyed"
  end
end
