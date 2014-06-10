# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140610013147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: true do |t|
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
    t.string   "zip_code"
    t.integer  "thirty_year_cash_flow"
    t.integer  "fifteen_year_cash_flow"
    t.float    "confidence_rate",                  default: 0.5
    t.boolean  "pmi_required",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
