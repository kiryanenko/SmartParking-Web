class Order < ApplicationRecord
  belongs_to :user
  belongs_to :parking_place

  scope :find_for_user, ->(id, user) { find_by! id: id, user: user }
  scope :user_orders, ->(user) { where(user: user).order(:id) }
end
