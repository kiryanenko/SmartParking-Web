class CreateSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :sensors, id: false do |t|
      t.integer :id, :primary_key, limit: 4
      t.belongs_to :user, index: true
      t.integer :sampling_period, default: 0, limit: 2
      t.integer :sending_period, default: 0, limit: 2
      t.integer :day_cast, default: 0, limit: 2
      t.integer :night_cast, default: 0, limit: 2
      t.integer :day_start_time, default: 0, limit: 2
      t.integer :night_start_time, default: 0, limit: 2

      t.timestamps
    end
    add_foreign_key :sensors, :users
  end
end
