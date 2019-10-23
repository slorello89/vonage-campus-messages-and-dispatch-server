# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_29_000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_logs", force: :cascade do |t|
    t.string "app_id"
    t.string "event_type"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nexmo_apps", force: :cascade do |t|
    t.string "api_key"
    t.string "app_id"
    t.string "name"
    t.text "public_key"
    t.text "private_key"
    t.string "inbound_url"
    t.string "inbound_url_method"
    t.string "status_url"
    t.string "status_url_method"
    t.string "number_msisdn"
    t.string "number_country"
    t.string "whatsapp_number"
    t.string "viber_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_nexmo_apps_on_app_id", unique: true
  end

end
