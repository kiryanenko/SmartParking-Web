require 'test_helper'

class ParkingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking = parkings(:one)
    @user = users(:owner)
  end

  # Отобразить страницу стоянок
  test "should get index" do
    sign_in @user
    get parkings_url
    assert_response :success
  end

  # Отобразить страницу добавления стоянки
  test "should get new" do
    sign_in @user
    get new_parking_url
    assert_response :success
  end

  # Создать стоянку
  test "should create parking" do
    sign_in @user

    assert_difference('Parking.count') do
      post parkings_url, params: { parking: {
          area: @parking.area,
          cost: @parking.cost,
          description: @parking.description,
          end_time: @parking.end_time,
          start_time: @parking.start_time,
          title: @parking.title } }
    end

    assert_redirected_to parking_url(Parking.last)
  end


  # Отобразить страницу стоянки
  test "should show parking" do
    sign_in @user
    get parking_url(id: @parking)
    assert_response :success
  end

  # Получить ошибку при попытки открыть страницу стоянки другого пользователя
  test "should get error in show parking for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      get parking_url(id: @parking)
    end
  end


  # Отобразить страницу изменения стоянки
  test "should get edit" do
    sign_in @user
    get edit_parking_url(id: @parking)
    assert_response :success
  end

  # Получить ошибку при попытки открыть страницу стоянки другого пользователя
  test "should get error in edit parking for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      get edit_parking_url(id: @parking)
    end
  end


  # Изменить стоянку
  test "should update parking" do
    sign_in @user
    patch parking_url(id: @parking), params: { parking: {
        area: @parking.area,
        cost: @parking.cost,
        description: @parking.description,
        end_time: @parking.end_time,
        start_time: @parking.start_time,
        title: @parking.title
    }}
    assert_redirected_to parking_url(@parking)
  end

  # Получить ошибку при попытки обновить стоянку другого пользователя
  test "should get error at updating parking for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      patch parking_url(id: @parking), params: { parking: {
          area: @parking.area,
          cost: @parking.cost,
          description: @parking.description,
          end_time: @parking.end_time,
          start_time: @parking.start_time,
          title: @parking.title
      }}
    end
  end


  # Удалить стоянку
  test "should destroy parking" do
    sign_in @user
    assert_difference('Parking.count', -1) do
      delete parking_url(id: @parking)
    end

    assert_redirected_to parkings_url
  end

  # Получить ошибку при попытки удалить стоянку другого пользователя
  test "should get error at deleting parking for other user" do
    sign_in users(:two)
    assert_raises ActiveRecord::RecordNotFound do
      delete parking_url(id: @parking)
    end
  end


  # В контроллере parkings перенаправить на страницу авторизации для не авторизованного пользователя
  test "should redirect to auth" do
    assert_redirected_to_auth(
        [parkings_url, 'get'],
        [parkings_url, 'post'],
        [new_parking_url, 'get'],
        [edit_parking_url(id: @parking), 'get'],
        [parking_url(id: @parking), 'get'],
        [parking_url(id: @parking), 'patch'],
        [parking_url(id: @parking), 'delete']
        )
  end
end
