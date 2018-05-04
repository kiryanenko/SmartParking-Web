class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true, null: false
      t.references :parking_place, index: true, null: false
      t.float :cost, default: 0, null: false
      t.float :payment, default: 0, null: false
      t.integer :order_time, limit: 4, null: false

      t.timestamps
    end
  end
end
