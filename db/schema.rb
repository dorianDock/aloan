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

ActiveRecord::Schema.define(version: 20170105171138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "borrowers", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "company_name"
    t.datetime "birth_date"
    t.float    "amount_wished"
    t.text     "project_description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "loans", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "contractual_end_date"
    t.datetime "end_date"
    t.boolean  "is_late"
    t.boolean  "is_in_default"
    t.float    "amount"
    t.float    "rate"
    t.integer  "borrower_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "loan_goal"
    t.integer  "order",                default: 1
  end

  create_table "step_types", force: :cascade do |t|
    t.string   "label"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "loan_id"
    t.integer  "step_type_id"
    t.datetime "expected_date"
    t.datetime "date_done"
    t.boolean  "is_done"
    t.float    "amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "loans", "borrowers"
  add_foreign_key "steps", "loans"
  add_foreign_key "steps", "step_types"
end
