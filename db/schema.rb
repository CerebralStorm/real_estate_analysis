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

ActiveRecord::Schema.define(version: 20160824174543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: :cascade do |t|
    t.string   "mls_number"
    t.string   "address"
    t.integer  "listing_price"
    t.integer  "down_payment",                     default: 0
    t.integer  "loan_amount"
    t.integer  "avg_rent"
    t.integer  "thirty_year_fixed"
    t.float    "thirty_year_fixed_interest_rate"
    t.integer  "fifteen_year_fixed"
    t.float    "fifteen_year_fixed_interest_rate"
    t.integer  "monthly_mortagage_insurance"
    t.integer  "monthly_property_taxes"
    t.integer  "monthly_hazard_insurance"
    t.integer  "square_footage"
    t.integer  "price_per_sq_foot",                default: 0
    t.integer  "price_for_even_cashflow",          default: 0
    t.integer  "thirty_year_cash_flow"
    t.integer  "fifteen_year_cash_flow"
    t.float    "confidence_rate",                  default: 0.5
    t.boolean  "pmi_required",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.float    "remodel_cost"
    t.integer  "number_of_bedrooms"
    t.integer  "potential_number_of_bedrooms"
    t.integer  "number_of_bathrooms"
    t.integer  "potential_number_of_bathrooms"
    t.string   "zpid"
    t.boolean  "hide",                             default: false
    t.integer  "zip_code_id"
    t.integer  "score"
    t.boolean  "hud",                              default: false
    t.string   "type"
    t.string   "url"
  end

  create_table "rental_calculations", force: :cascade do |t|
    t.integer  "listing_id"
    t.float    "purchase_price"
    t.float    "after_repair_value"
    t.float    "closing_cost"
    t.float    "repair_cost"
    t.float    "interest_rate"
    t.float    "other_lender_charges"
    t.float    "lender_points"
    t.integer  "down_payment"
    t.integer  "loan_amount"
    t.integer  "loan_duration"
    t.integer  "vacancy"
    t.integer  "repairs"
    t.integer  "capital_expenditures"
    t.integer  "property_management"
    t.integer  "annual_income_growth"
    t.integer  "appreciation"
    t.integer  "annual_expense_growth"
    t.integer  "sales_expense"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "median_listing_price"
    t.integer  "average_listing_price"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.float    "price_to_rent_ratio"
    t.float    "median_rent"
    t.float    "estimated_rent"
    t.boolean  "favorite",              default: false
  end

end
