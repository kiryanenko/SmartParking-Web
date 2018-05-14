require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Успешная валидация
  test "valid order" do
    order = orders(:one)
    assert order.valid?
  end

  # Не валидный заказ для занятого парковочного места
  test "not valid order for not free parking place" do
    order = orders(:not_free_parking)
    assert_raise Order::ParkingPlaceNotFree do
      order.valid?
    end

    order = orders(:booked_parking)
    assert_raise Order::ParkingPlaceNotFree do
      order.valid?
    end

    order = orders(:disconnected_parking)
    assert_raise Order::ParkingPlaceNotFree do
      order.valid?
    end
  end

  # Оплата через платежный терминал
  test "terminal payment" do
    order = orders(:terminal_payment)
    assert order.valid?
    assert order.payment_terminal?
  end

  # Заказ для бесплатной парковки
  test "order without payment" do
    order = orders(:order_without_payment)
    assert order.valid?
  end

  # Не достаточно средств
  test "not enough money" do
    order = orders(:not_enough_money)
    assert_raise Order::NotEnoughMoney do
      order.valid?
    end
  end

  # Требуется платеж
  test "need payment" do
    order = orders(:need_payment)
    assert_raise Order::NeedPayment do
      order.valid?
    end
  end

  # Проверка соответствия стоимости
  test "check cost" do
    order = orders(:one)
    payment = Order.payment(order.user, order.parking_place, order.booked_time)
    assert_equal order.parking_place.parking.cost, payment.cost

    order = orders(:one)
    payment = Order.payment(order.user, order.parking_place, 2 * order.booked_time)
    assert_equal 2 * order.parking_place.parking.cost, payment.cost
  end

end
