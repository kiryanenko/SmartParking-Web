class CreateParkings < ActiveRecord::Migration[5.2]
  def change
    create_table :parkings do |t|
      t.string :title
      t.text :description
      t.float :cost, default: 0, index: true
      t.references :user, foreign_key: true, index: true
      t.st_polygon :area, geographic: true, index: true
      t.time :start_time, null: true, index: true
      t.time :end_time, null: true, index: true

      t.timestamps
    end
  end
end
