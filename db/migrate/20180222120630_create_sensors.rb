class CreateSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :sensors, id: false do |t|
      t.integer :id, primary_key: true, limit: 4, null: false
      t.belongs_to :user, index: true, null: false
      t.integer :sampling_period, default: 0, limit: 2, null: false
      t.integer :sending_period, default: 0, limit: 2, null: false
      t.integer :day_cost, default: 0, limit: 2, null: false
      t.integer :night_cost, default: 0, limit: 2, null: false
      t.integer :day_start_time, default: 0, limit: 2, null: false
      t.integer :night_start_time, default: 0, limit: 2, null: false

      t.timestamps
    end
    add_foreign_key :sensors, :users
  end
end
