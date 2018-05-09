require 'test_helper'

class ParkingPlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking_place = parking_places(:one)
    @user = users(:owner)
  end

  # test "should get index" do
  #   get parking_places_url
  #   assert_response :success
  # end

  # Отобразить страницу добавления парковочного места
  test "should get parking place new page" do
    sign_in @user
    get new_parking_parking_place_url parking_id: @parking_place.parking
    assert_response :success
  end

  # Создать новое парковочное место
  test "should create parking place" do
    sign_in @user

    assert_difference('ParkingPlace.count') do
      post parking_parking_places_url(parking_id: @parking_place.parking_id), params: { parking_place: {
          can_book: @parking_place.can_book,
          coord: @parking_place.coord,
          for_disabled: @parking_place.for_disabled,
          place_id: @parking_place.place_id + 100,
          sensor_id: @parking_place.sensor_id,
          title: @parking_place.title
      }}
    end

    assert_redirected_to parking_place_url(ParkingPlace.last)
  end

  # Отобразить страницу парковочного места
  test "should show parking place" do
    sign_in @user
    get parking_place_url(id: @parking_place)
    assert_response :success
  end

  # Отобразить страницу изменения парковочного места
  test "should get parking place edit page" do
    sign_in @user
    get edit_parking_place_url(id: @parking_place)
    assert_response :success
  end

  # Изменить парковочное место
  test "should update parking_place" do
    sign_in @user
    patch parking_place_url(id: @parking_place), params: { parking_place: {
        coord: @parking_place.coord,
        for_disabled: @parking_place.for_disabled,
        parking_id: @parking_place.parking_id,
        place_id: @parking_place.place_id,
        sensor_id: @parking_place.sensor_id,
        title: @parking_place.title
    }}
    assert_redirected_to parking_place_url(@parking_place)
  end

  # Удалить парковочное место
  test "should destroy parking_place" do
    sign_in @user
    assert_difference('ParkingPlace.count', -1) do
      delete parking_place_url(id: @parking_place)
    end

    assert_redirected_to parking_places_url
  end

  # В контроллере parking places перенаправить на страницу авторизации для не авторизованного пользователя
  test "should redirect to auth" do
    assert_redirected_to_auth(
        [new_parking_parking_place_url(parking_id: @parking_place.parking), 'get'],
        [parking_parking_places_url(parking_id: @parking_place.parking_id), 'get'],
        [parking_place_orders_url(parking_place_id: @parking_place.id), 'post'],
        [parking_place_url(id: @parking_place), 'get'],
        [parking_place_url(id: @parking_place), 'patch'],
        [edit_parking_place_url(id: @parking_place), 'get'],
    )
  end
end
