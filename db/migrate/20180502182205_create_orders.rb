class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :parking_place, index: true
      t.float :cost, default: 0
      t.float :payment, default: 0

      t.timestamps
    end
  end
end
