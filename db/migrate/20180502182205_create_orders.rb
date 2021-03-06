class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true, null: true
      t.references :parking_place, index: true, null: false
      t.float :cost, default: 0, null: false
      t.float :payment, default: 0, null: false
      t.integer :booked_time, limit: 4, null: false
      t.timestamp :end_time, index: true, null: false
      t.boolean :active, default: true, index: true, null: false

      t.timestamps
    end
  end
end
