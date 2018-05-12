require 'test_helper'

class SensorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sensor = sensors(:one)
    @user = users(:owner)
  end

  # Отобразить страницу сенсоров
  test "should get sensor index" do
    sign_in @user
    get sensors_url
    assert_response :success
  end

  # test "should get sensor new" do
  #   get new_sensor_url
  #   assert_response :success
  # end

  # Создание нового сенсора
  test "should create sensor" do
    assert_difference('Sensor.count') do
      sign_in @user
      post sensors_url
    end

    assert_redirected_to sensors_url
  end


  # Отобразить страницу сенсора
  test "should show sensor" do
    sign_in @user
    get sensor_url(id: @sensor)
    assert_response :success
  end

  # Получить ошибку при попытки открыть страницу сенсора другого пользователя
  test "should get error in show sensor for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      get sensor_url(id: @sensor)
    end
  end


  # Отобразить страницу изменения сенсора
  test "should get edit" do
    sign_in @user
    get edit_sensor_url(id: @sensor)
    assert_response :success
  end

  # Получить ошибку при попытки открыть страницу сенсора другого пользователя
  test "should get error in edit sensor for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      get edit_sensor_url(id: @sensor)
    end
  end


  # Изменить сенсор
  test "should update sensor" do
    sign_in @user
    patch sensor_url(id: @sensor), params: { sensor: {
        day_cost: @sensor.day_cost,
        day_start_time: '07:00',
        night_cost: @sensor.night_cost,
        night_start_time: '22:30',
        sampling_period: @sensor.sampling_period,
        sending_period: @sensor.sending_period
    }}
    assert_redirected_to sensors_path
  end

  # Получить ошибку при попытки изменить сенсор другого пользователя
  test "should get error at updating sensor for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      patch sensor_url(id: @sensor), params: { sensor: {
          day_cost: @sensor.day_cost,
          day_start_time: '07:00',
          night_cost: @sensor.night_cost,
          night_start_time: '22:30',
          sampling_period: @sensor.sampling_period,
          sending_period: @sensor.sending_period
      }}
    end
  end


  # Удалить сенсор
  test "should destroy sensor" do
    sign_in @user
    assert_difference('Sensor.count', -1) do
      delete sensor_url(id: @sensor)
    end

    assert_redirected_to sensors_url
  end

  # Получить ошибку при попытки изменить сенсор другого пользователя
  test "should get error at deleting sensor for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      delete sensor_url(id: @sensor)
    end
  end


  # В контроллере sensors перенаправить на страницу авторизации для не авторизованного пользователя
  test "should redirect to auth" do
    assert_redirected_to_auth(
        [sensors_url, 'get'],
        [sensors_url, 'post'],
        [edit_sensor_url(id: @sensor), 'get'],
        [sensor_url(id: @sensor), 'get'],
        [sensor_url(id: @sensor), 'patch'],
        [sensor_url(id: @sensor), 'delete']
    )
  end
end
