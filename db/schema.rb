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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110113173905) do

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "metadata"
    t.string   "alpha_code"
    t.string   "alpha_mask"
    t.string   "digit_code"
    t.string   "digit_mask"
    t.string   "category_one"
    t.float    "amount_one",        :default => 0.0
    t.float    "percentage_one",    :default => 0.0
    t.string   "category_two"
    t.float    "amount_two",        :default => 0.0
    t.float    "percentage_two",    :default => 0.0
    t.date     "expiration"
    t.integer  "how_many",          :default => 1
    t.integer  "redemptions_count", :default => 0
    t.integer  "integer",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["alpha_code"], :name => "index_coupons_on_alpha_code"
  add_index "coupons", ["digit_code"], :name => "index_coupons_on_digit_code"

  create_table "redemptions", :force => true do |t|
    t.integer  "coupon_id"
    t.string   "user_id"
    t.string   "transaction_id"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
