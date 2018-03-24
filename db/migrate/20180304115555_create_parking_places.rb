class CreateParkingPlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_places do |t|
      t.integer :place_id, limit: 2, null: false, index: true
      t.references :sensor, foreign_key: true, null: false, index: true
      t.references :parking, foreign_key: true, null: false, index: true
      t.string :title, null: false
      t.st_point :coord, geographic: true, null: false
      t.boolean :for_disabled, default: false, null: false, index: true
      t.boolean :booked, default: false, null: false, index: true
      t.boolean :free, default: false, null: false, index: true
      t.boolean :connected, default: false, null: false, index: true
      t.boolean :can_book, default: false, null: false, index: true
      t.boolean :changed_state, default: false, null: false, index: true

      t.timestamps

      t.index :coord, using: :gist
      t.index :updated_at
    end
  end
end
