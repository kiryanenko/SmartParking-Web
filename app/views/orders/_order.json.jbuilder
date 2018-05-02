json.extract! order, :id, :user, :parking_place, :cost, :payment, :created_at, :updated_at
json.url order_url(order, format: :json)
