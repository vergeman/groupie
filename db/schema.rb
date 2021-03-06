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

ActiveRecord::Schema.define(:version => 20110723054355) do

  create_table "events", :force => true do |t|
    t.integer  "admin_id"
    t.string   "title"
    t.string   "description"
    t.datetime "event_date"
    t.integer  "starting_votes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_key"
    t.boolean  "sent_expiry_email"
  end

  add_index "events", ["admin_id"], :name => "index_events_on_admin_id"

  create_table "groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "event_id"
  end

  add_index "groups", ["event_id"], :name => "index_groups_on_event_id"
  add_index "groups", ["user_id", "event_id"], :name => "index_groups_on_user_id_and_event_id", :unique => true
  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "participants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "votes_remaining"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["event_id"], :name => "index_participants_on_event_id"
  add_index "participants", ["user_id"], :name => "index_participants_on_user_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cid"
    t.string   "address"
    t.string   "neighborhood"
    t.string   "rating"
    t.string   "price"
    t.string   "reference"
    t.string   "url"
    t.text     "comments"
    t.text     "external_links"
    t.text     "image_links"
  end

  add_index "places", ["cid"], :name => "index_places_on_cid"

  create_table "schedules", :force => true do |t|
    t.integer  "event_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "place_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
