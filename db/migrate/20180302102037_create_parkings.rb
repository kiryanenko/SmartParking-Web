class CreateParkings < ActiveRecord::Migration[5.2]
  def change
    create_table :parkings do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.float :cost, default: 0, null: false, index: true
      t.references :user, foreign_key: true, null: false, index: true
      t.st_polygon :area, geographic: true, null: false
      t.time :start_time, null: true, index: true
      t.time :end_time, null: true, index: true
      t.integer :parking_places_count, default: 0, null: false

      t.timestamps

      t.index :area, using: :gist
    end
  end
end
