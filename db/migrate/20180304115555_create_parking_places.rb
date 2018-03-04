class CreateParkingPlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_places do |t|
      t.integer :place_id, limit: 2, index: true
      t.references :sensor, foreign_key: true, index: true
      t.references :parking, foreign_key: true, index: true
      t.string :title
      t.st_point :coord, geographic: true, index: true
      t.boolean :for_disabled, default: false, index: true
      t.boolean :booked, default: false, index: true
      t.boolean :free, default: false, index: true
      t.boolean :connected, default: false, index: true
      t.boolean :can_book, default: false, index: true

      t.timestamps
    end
  end
end
