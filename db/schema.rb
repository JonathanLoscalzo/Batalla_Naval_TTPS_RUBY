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

ActiveRecord::Schema.define(version: 20150123225441) do

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "breed_id"
    t.integer  "user_id"
    t.boolean  "setted",     default: false
  end

  add_index "boards", ["breed_id"], name: "index_boards_on_breed_id"

  create_table "breeds", force: :cascade do |t|
    t.integer  "size"
    t.integer  "count_ships"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id",            default: 1
    t.integer  "last_user_move_id_id"
    t.integer  "board1_id_id"
    t.integer  "board2_id_id"
  end

  add_index "games", ["last_user_move_id_id"], name: "index_games_on_last_user_move_id_id"
  add_index "games", ["status_id"], name: "index_games_on_status_id"

  create_table "ships", force: :cascade do |t|
    t.integer  "board_id"
    t.boolean  "sunken",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
  end

  add_index "ships", ["board_id"], name: "index_ships_on_board_id"

  create_table "statuses", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 20, null: false
    t.text     "password",   limit: 20, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waters", force: :cascade do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waters", ["board_id"], name: "index_waters_on_board_id"

end
