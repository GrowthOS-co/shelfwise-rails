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

ActiveRecord::Schema[8.1].define(version: 2026_10_04_000005) do
  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "author", null: false
    t.string "isbn", null: false
    t.string "genre", null: false
    t.integer "published_year", null: false
    t.text "description", null: false
    t.integer "price_cents", null: false
    t.integer "stock", null: false
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "book_id", null: false
    t.integer "quantity", null: false
    t.index ["book_id"], name: "index_cart_items_on_book_id"
    t.index ["cart_id", "book_id"], name: "index_cart_items_on_cart_id_and_book_id", unique: true
  end

  create_table "carts", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["token"], name: "index_carts_on_token", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "book_id", null: false
    t.string "title", null: false
    t.integer "unit_price_cents", null: false
    t.integer "quantity", null: false
    t.index ["book_id"], name: "index_order_items_on_book_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "number", null: false
    t.string "customer_name", null: false
    t.string "email", null: false
    t.text "shipping_address", null: false
    t.string "status", default: "placed", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "shipped_at"
    t.index ["number"], name: "index_orders_on_number", unique: true
  end

  add_foreign_key "cart_items", "books"
  add_foreign_key "cart_items", "carts", on_delete: :cascade
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "orders", on_delete: :cascade
end
