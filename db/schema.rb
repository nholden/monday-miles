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

ActiveRecord::Schema.define(version: 20180120190657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "strava_id"
    t.string "name"
    t.integer "distance"
    t.integer "moving_time"
    t.integer "elapsed_time"
    t.integer "total_elevation_gain"
    t.string "activity_type"
    t.datetime "start_time"
    t.integer "utc_offset"
    t.float "start_lat"
    t.float "start_lng"
    t.float "end_lat"
    t.float "end_lng"
    t.string "city"
    t.string "state"
    t.string "country"
    t.text "polyline"
    t.float "elev_high"
    t.float "elev_low"
    t.float "average_temp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "monday"
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "strava_id"
    t.string "medium_profile_image_url"
    t.string "large_profile_image_url"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "gender"
    t.string "email"
    t.string "strava_access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_signed_in_at"
    t.string "slug", null: false
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

end
