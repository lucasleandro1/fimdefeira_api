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

ActiveRecord::Schema[8.0].define(version: 2025_05_09_224501) do
  create_table "branches", force: :cascade do |t|
    t.integer "supermarket_id", null: false
    t.string "address"
    t.string "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supermarket_id"], name: "index_branches_on_supermarket_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "supermarket_id", null: false
    t.integer "product_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_posts_on_product_id"
    t.index ["supermarket_id"], name: "index_posts_on_supermarket_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "supermarket_id", null: false
    t.string "name"
    t.date "expiration_date"
    t.decimal "price"
    t.integer "stock_quantity"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supermarket_id"], name: "index_products_on_supermarket_id"
  end

  create_table "supermarkets", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cnpj"
    t.string "address"
    t.string "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_supermarkets_on_email", unique: true
    t.index ["reset_password_token"], name: "index_supermarkets_on_reset_password_token", unique: true
  end

  create_table "ticket_items", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "quantity"
    t.decimal "subtotal_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id", null: false
    t.index ["post_id"], name: "index_ticket_items_on_post_id"
    t.index ["ticket_id"], name: "index_ticket_items_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "supermarket_id", null: false
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_tickets_on_client_id"
    t.index ["supermarket_id"], name: "index_tickets_on_supermarket_id"
  end

  add_foreign_key "branches", "supermarkets"
  add_foreign_key "posts", "products"
  add_foreign_key "posts", "supermarkets"
  add_foreign_key "products", "supermarkets"
  add_foreign_key "ticket_items", "posts"
  add_foreign_key "ticket_items", "tickets"
  add_foreign_key "tickets", "clients"
  add_foreign_key "tickets", "supermarkets"
end
