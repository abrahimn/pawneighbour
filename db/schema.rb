# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_08_041617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alert_responses", force: :cascade do |t|
    t.bigint "amber_alert_id", null: false
    t.datetime "created_at", null: false
    t.date "date"
    t.text "notes"
    t.bigint "spotter_id", null: false
    t.time "time"
    t.datetime "updated_at", null: false
    t.index ["amber_alert_id"], name: "index_alert_responses_on_amber_alert_id"
    t.index ["spotter_id"], name: "index_alert_responses_on_spotter_id"
  end

  create_table "amber_alerts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.date "date"
    t.string "location"
    t.bigint "pet_id", null: false
    t.time "time"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_amber_alerts_on_creator_id"
    t.index ["pet_id"], name: "index_amber_alerts_on_pet_id"
  end

  create_table "connections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_connections_on_receiver_id"
    t.index ["sender_id"], name: "index_connections_on_sender_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.text "details"
    t.string "location"
    t.string "name"
    t.bigint "organiser_id", null: false
    t.string "photo_url"
    t.time "time"
    t.datetime "updated_at", null: false
    t.index ["organiser_id"], name: "index_events_on_organiser_id"
  end

  create_table "listings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "listing_note"
    t.string "listing_type"
    t.bigint "pet_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_listings_on_pet_id"
  end

  create_table "offers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "listing_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["listing_id"], name: "index_offers_on_listing_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "pets", force: :cascade do |t|
    t.integer "age"
    t.text "care_instructions"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "profile_pic"
    t.string "species"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.bigint "responder_id", null: false
    t.string "response"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["responder_id"], name: "index_rsvps_on_responder_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "mobile"
    t.string "name"
    t.string "profile_pic"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alert_responses", "amber_alerts"
  add_foreign_key "alert_responses", "users", column: "spotter_id"
  add_foreign_key "amber_alerts", "pets"
  add_foreign_key "amber_alerts", "users", column: "creator_id"
  add_foreign_key "connections", "users", column: "receiver_id"
  add_foreign_key "connections", "users", column: "sender_id"
  add_foreign_key "events", "users", column: "organiser_id"
  add_foreign_key "listings", "pets"
  add_foreign_key "offers", "listings"
  add_foreign_key "offers", "users"
  add_foreign_key "pets", "users"
  add_foreign_key "rsvps", "users", column: "event_id"
  add_foreign_key "rsvps", "users", column: "responder_id"
end
