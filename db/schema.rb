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

ActiveRecord::Schema.define(version: 2022_08_15_085926) do

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "discounts", charset: "utf8mb3", force: :cascade do |t|
    t.decimal "discount_rate", precision: 10
    t.boolean "activated", default: true
    t.bigint "tour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_discounts_on_tour_id"
  end

  create_table "request_histories", charset: "utf8mb3", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "total_price", precision: 10
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.bigint "tour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_request_histories_on_tour_id"
    t.index ["user_id"], name: "index_request_histories_on_user_id"
  end

  create_table "reviews", charset: "utf8mb3", force: :cascade do |t|
    t.decimal "rating", precision: 5, scale: 1
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "tour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_reviews_on_tour_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tour_requests", charset: "utf8mb3", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "total_price", precision: 5, scale: 1
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.bigint "tour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_tour_requests_on_tour_id"
    t.index ["user_id"], name: "index_tour_requests_on_user_id"
  end

  create_table "tours", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 5, scale: 1
    t.decimal "avg_rating", precision: 5, scale: 1
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "stock"
    t.index ["category_id"], name: "index_tours_on_category_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "role", default: 1
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "discounts", "tours"
  add_foreign_key "request_histories", "tours"
  add_foreign_key "request_histories", "users"
  add_foreign_key "reviews", "tours"
  add_foreign_key "reviews", "users"
  add_foreign_key "tour_requests", "tours"
  add_foreign_key "tour_requests", "users"
  add_foreign_key "tours", "categories"
end
