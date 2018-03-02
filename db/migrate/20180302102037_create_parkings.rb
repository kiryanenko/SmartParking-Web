class CreateParkings < ActiveRecord::Migration[5.2]
  def change
    create_table :parkings do |t|
      t.text :title
      t.text :description
      t.float :cost, default: 0
      t.references :user, foreign_key: true
      t.st_polygon :area, geographic: true
      t.time :start_time, null: true
      t.time :end_time, null: true

      t.timestamps
    end
  end
end
