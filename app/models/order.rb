class Order < ApplicationRecord
  belongs_to :user
  belongs_to :parking_place

  before_validation :payment_not_nil

  validate :need_payment, :enough_money, :parking_place_is_free

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_orders, ->(user) { where(user: user).order(:id) }

  def payment_not_nil
    self.payment = 0 if self.payment.nil?
  end

  def need_payment
    if self.cost > 0 and self.payment.zero?
      raise NeedPayment
    end
  end

  def enough_money
    if self.payment < self.cost
      errors.add(:payment, I18n.t(:not_enough_money))
      raise NotEnoughMoney
    end
  end

  def parking_place_is_free
    if self.payment < self.cost
      errors.add(:base, I18n.t(:parking_place_not_free))
      raise ParkingPlaceNotFree
    end
  end

  def self.payment(user, parking_place, order_time, payment = 0)
    Order.new(
        user: user,
        parking_place: parking_place,
        order_time: order_time,
        cost: parking_place.parking.cost * order_time * 1.0 / 1.hour,
        payment: payment
    )
  end

  class NeedPayment < StandardError
  end

  class NotEnoughMoney < StandardError
  end

  class ParkingPlaceNotFree < StandardError
  end
end
