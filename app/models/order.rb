class Order < ApplicationRecord
  belongs_to :user
  belongs_to :parking_place
end
