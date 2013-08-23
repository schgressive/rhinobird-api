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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130822195433) do

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "hash_token", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channels", ["hash_token"], :name => "index_channels_on_hash_token", :unique => true

  create_table "channels_streams", :id => false, :force => true do |t|
    t.integer "channel_id"
    t.integer "stream_id"
  end

  add_index "channels_streams", ["channel_id", "stream_id"], :name => "index_channels_streams_on_channel_id_and_stream_id"

  create_table "stream_pools", :force => true do |t|
    t.integer  "stream_id"
    t.integer  "user_id"
    t.boolean  "active",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "stream_pools", ["stream_id"], :name => "index_stream_pools_on_stream_id"
  add_index "stream_pools", ["user_id"], :name => "index_stream_pools_on_user_id"

  create_table "streams", :force => true do |t|
    t.string   "caption"
    t.string   "hash_token",                                                               :null => false
    t.decimal  "lat",                    :precision => 18, :scale => 12
    t.decimal  "lng",                    :precision => 18, :scale => 12
    t.string   "geo_reference"
    t.datetime "started_on"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.integer  "user_id"
    t.boolean  "live",                                                   :default => true
  end

  add_index "streams", ["hash_token"], :name => "index_streams_on_hash_token", :unique => true
  add_index "streams", ["user_id"], :name => "index_streams_on_user_id"

  create_table "streams_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "stream_id"
  end

  add_index "streams_tags", ["stream_id"], :name => "index_streams_tags_on_stream_id"
  add_index "streams_tags", ["tag_id"], :name => "index_streams_tags_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "username"
    t.string   "vj_room"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
