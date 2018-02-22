require "application_system_test_case"

class SensorsTest < ApplicationSystemTestCase
  setup do
    @sensor = sensors(:one)
  end

  test "visiting the index" do
    visit sensors_url
    assert_selector "h1", text: "Sensors"
  end

  test "creating a Sensor" do
    visit sensors_url
    click_on "New Sensor"

    fill_in "Day Cast", with: @sensor.day_cast
    fill_in "Day Start Time", with: @sensor.day_start_time
    fill_in "Id", with: @sensor.id
    fill_in "Night Cast", with: @sensor.night_cast
    fill_in "Night Start Time", with: @sensor.night_start_time
    fill_in "Sampling Period", with: @sensor.sampling_period
    fill_in "Sending Period", with: @sensor.sending_period
    fill_in "User", with: @sensor.user_id
    click_on "Create Sensor"

    assert_text "Sensor was successfully created"
    click_on "Back"
  end

  test "updating a Sensor" do
    visit sensors_url
    click_on "Edit", match: :first

    fill_in "Day Cast", with: @sensor.day_cast
    fill_in "Day Start Time", with: @sensor.day_start_time
    fill_in "Id", with: @sensor.id
    fill_in "Night Cast", with: @sensor.night_cast
    fill_in "Night Start Time", with: @sensor.night_start_time
    fill_in "Sampling Period", with: @sensor.sampling_period
    fill_in "Sending Period", with: @sensor.sending_period
    fill_in "User", with: @sensor.user_id
    click_on "Update Sensor"

    assert_text "Sensor was successfully updated"
    click_on "Back"
  end

  test "destroying a Sensor" do
    visit sensors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sensor was successfully destroyed"
  end
end
