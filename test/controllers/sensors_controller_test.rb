require 'test_helper'

class SensorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sensor = sensors(:one)
  end

  test "should get index" do
    get sensors_url
    assert_response :success
  end

  test "should get new" do
    get new_sensor_url
    assert_response :success
  end

  test "should create sensor" do
    assert_difference('Sensor.count') do
      post sensors_url, params: { sensor: { day_cast: @sensor.day_cast, day_start_time: @sensor.day_start_time, id: @sensor.id, night_cast: @sensor.night_cast, night_start_time: @sensor.night_start_time, sampling_period: @sensor.sampling_period, sending_period: @sensor.sending_period, user_id: @sensor.user_id } }
    end

    assert_redirected_to sensor_url(Sensor.last)
  end

  test "should show sensor" do
    get sensor_url(@sensor)
    assert_response :success
  end

  test "should get edit" do
    get edit_sensor_url(@sensor)
    assert_response :success
  end

  test "should update sensor" do
    patch sensor_url(@sensor), params: { sensor: { day_cast: @sensor.day_cast, day_start_time: @sensor.day_start_time, id: @sensor.id, night_cast: @sensor.night_cast, night_start_time: @sensor.night_start_time, sampling_period: @sensor.sampling_period, sending_period: @sensor.sending_period, user_id: @sensor.user_id } }
    assert_redirected_to sensor_url(@sensor)
  end

  test "should destroy sensor" do
    assert_difference('Sensor.count', -1) do
      delete sensor_url(@sensor)
    end

    assert_redirected_to sensors_url
  end
end
