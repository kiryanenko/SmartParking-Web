class CreateParkingStates < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_states do |t|
      t.references :parking_place, foreign_key: true, index: true
      t.boolean :booked
      t.boolean :free

      t.timestamps
    end
  end
end
