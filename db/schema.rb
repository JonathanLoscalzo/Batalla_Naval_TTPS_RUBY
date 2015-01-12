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

ActiveRecord::Schema.define(version: 20150112204956) do

  create_table "boards", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["game_id"], name: "index_boards_on_game_id"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id",            default: 1
    t.integer  "user1_id_id"
    t.integer  "user2_id_id"
    t.integer  "last_user_move_id_id"
  end

  add_index "games", ["last_user_move_id_id"], name: "index_games_on_last_user_move_id_id"
  add_index "games", ["status_id"], name: "index_games_on_status_id"
  add_index "games", ["user1_id_id"], name: "index_games_on_user1_id_id"
  add_index "games", ["user2_id_id"], name: "index_games_on_user2_id_id"

  create_table "ships", force: :cascade do |t|
    t.integer  "board_id"
    t.boolean  "sunken",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
