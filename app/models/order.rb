class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :parking_place

  before_validation :payment_not_nil
  before_create :set_end_time
  after_create :book

  validate :need_payment, :enough_money, :parking_place_is_free, unless: :payment_terminal?

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_orders, ->(user) { where(user: user).order(id: :desc) }

  scope :owner_orders, ->(user) do
    joins(parking_place: :parking).where(parking_places: {parkings: {user: user}}).order(id: :desc)
  end

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

  def payment_terminal?
    self.user.nil?
  end

  def parking_place_is_free
    place = self.parking_place
    if not place.can_book or not place.free or place.booked or not place.connected
      errors.add(:base, I18n.t(:parking_place_not_free))
      raise ParkingPlaceNotFree
    end
  end

  def self.payment(user, parking_place, order_time, payment = 0, cost = nil)
    cost = parking_place.parking.cost * order_time * 1.0 / 1.hour if cost.nil?
    Order.new(
        user: user,
        parking_place: parking_place,
        booked_time: order_time,
        cost: cost,
        payment: payment
    )
  end

  def self.stop_reservations
    orders_to_finish = where(active: true).where('end_time < now()')
    ParkingPlace.joins(:orders).where(orders: orders_to_finish).update_all(booked: false)
    orders_to_finish.update_all(active: false)
  end

  class NeedPayment < StandardError
  end

  class NotEnoughMoney < StandardError
  end

  class ParkingPlaceNotFree < StandardError
  end

  private
  def book
    self.parking_place.book(self.booked_time) unless self.user.nil?
  end

  def set_end_time
    self.end_time = Time.now + self.booked_time
  end
end
