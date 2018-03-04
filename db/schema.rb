# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_03_04_115555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "parking_places", force: :cascade do |t|
    t.integer "place_id", limit: 2
    t.bigint "sensor_id"
    t.bigint "parking_id"
    t.string "title"
    t.geography "coord", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.boolean "for_disabled", default: false
    t.boolean "booked", default: false
    t.boolean "free", default: false
    t.boolean "connected", default: false
    t.boolean "can_book", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booked"], name: "index_parking_places_on_booked"
    t.index ["can_book"], name: "index_parking_places_on_can_book"
    t.index ["connected"], name: "index_parking_places_on_connected"
    t.index ["coord"], name: "index_parking_places_on_coord"
    t.index ["for_disabled"], name: "index_parking_places_on_for_disabled"
    t.index ["free"], name: "index_parking_places_on_free"
    t.index ["parking_id"], name: "index_parking_places_on_parking_id"
    t.index ["place_id"], name: "index_parking_places_on_place_id"
    t.index ["sensor_id"], name: "index_parking_places_on_sensor_id"
  end

  create_table "parkings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.float "cost", default: 0.0
    t.bigint "user_id"
    t.geography "area", limit: {:srid=>4326, :type=>"st_polygon", :geographic=>true}
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_parkings_on_area"
    t.index ["cost"], name: "index_parkings_on_cost"
    t.index ["end_time"], name: "index_parkings_on_end_time"
    t.index ["start_time"], name: "index_parkings_on_start_time"
    t.index ["user_id"], name: "index_parkings_on_user_id"
  end

  create_table "sensors", id: :serial, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "sampling_period", limit: 2, default: 0
    t.integer "sending_period", limit: 2, default: 0
    t.integer "day_cast", limit: 2, default: 0
    t.integer "night_cast", limit: 2, default: 0
    t.integer "day_start_time", limit: 2, default: 0
    t.integer "night_start_time", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sensors_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", null: false
    t.string "phone", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "parking_places", "parkings"
  add_foreign_key "parking_places", "sensors"
  add_foreign_key "parkings", "users"
  add_foreign_key "sensors", "users"
end
