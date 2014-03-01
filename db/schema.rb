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

ActiveRecord::Schema.define(version: 20140301060852) do

  create_table "channels", force: true do |t|
    t.string   "slack_id"
    t.string   "name"
    t.datetime "last_check"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels", ["slack_id"], name: "index_channels_on_slack_id", unique: true

  create_table "messages", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.string   "subtype"
    t.string   "text"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["channel_id", "user_id", "timestamp"], name: "index_messages_on_channel_id_and_user_id_and_timestamp", unique: true
  add_index "messages", ["timestamp"], name: "index_messages_on_timestamp"

  create_table "users", force: true do |t|
    t.string   "slack_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["slack_id"], name: "index_users_on_slack_id", unique: true

end
