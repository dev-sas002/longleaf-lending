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

ActiveRecord::Schema.define(version: 2024_07_12_135335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loan_requests", force: :cascade do |t|
    t.string "address", null: false
    t.integer "loan_term", null: false
    t.integer "purchase_price", null: false
    t.integer "repair_budget", null: false
    t.integer "arv", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "email", null: false
    t.string "phone", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_loan_requests_on_email", unique: true
    t.check_constraint "(loan_term > 0) AND (loan_term <= 12)", name: "loan_term_range"
    t.check_constraint "arv > 0", name: "arv_positive"
    t.check_constraint "purchase_price > 0", name: "purchase_price_positive"
    t.check_constraint "repair_budget > 0", name: "repair_budget_positive"
  end

end
