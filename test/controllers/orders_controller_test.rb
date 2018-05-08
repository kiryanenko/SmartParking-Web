require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @order = orders(:one)
    @user = users(:one)
    @parking_place = parking_places(:one)
  end

  # Отобразить страницу со списком заказов
  test "should get order index" do
    sign_in @user
    get orders_url
    assert_response :success
  end

  # Отобразить страницу создания заказа
  test "should get order new" do
    sign_in @user
    get new_parking_place_order_url parking_place_id: @parking_place.id
    assert_response :success
  end

  # Создать новый заказ
  test "should create order" do
    sign_in @user
    assert_difference('Order.count') do
      post parking_place_orders_url(parking_place_id: @parking_place.id),
           params: { order: { payment: @order.payment, booked_time: @order.booked_time} }
    end

    assert_redirected_to order_url(Order.last)
  end

  # Создать заказ для бесплатной парковки без оплаты
  test "should create order for free parking" do
    sign_in @user
    order = orders(:order_without_payment)
    assert_difference('Order.count') do
      post parking_place_orders_url(parking_place_id: order.parking_place),
           params: { order: { booked_time: @order.booked_time} }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { cost: @order.cost, parking_place: @order.parking_place, payment: @order.payment, user: @order.user } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end

  # В контроллере orders перенаправить на страницу авторизации для не авторизованного пользователя
  test "should redirect to auth" do
    assert_redirected_to_auth(
        [orders_url, 'get'],
        [new_parking_place_order_url(parking_place_id: @parking_place.id), 'get'],
        [parking_place_orders_url(parking_place_id: @parking_place.id), 'post'],
        [control_panel_orders_url, 'get'],
        [control_panel_orders_url, 'get'],
    )
  end
end
