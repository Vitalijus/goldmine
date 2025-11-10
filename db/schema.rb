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

ActiveRecord::Schema[8.0].define(version: 2025_11_10_100135) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "careers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "location"
    t.string "employment_type"
    t.string "salary_range"
    t.boolean "active"
    t.text "keywords", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "about_us"
    t.text "about_role"
    t.text "reqs"
    t.text "our_culture"
    t.text "how_to_apply"
  end

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "programming_languages", default: [], null: false, array: true
    t.text "frameworks", default: [], null: false, array: true
    t.text "other_tech_stack", default: [], null: false, array: true
    t.text "countries", default: [], null: false, array: true
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "stripe_payment_intent"
    t.integer "amount"
    t.string "stripe_product_id"
    t.string "client_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
