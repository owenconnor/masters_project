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

ActiveRecord::Schema.define(:version => 20130116214022) do

  create_table "authors", :force => true do |t|
    t.string   "author_name"
    t.string   "author_url"
    t.integer  "trusted_uploader_rank", :default => 1, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "authors", ["author_url"], :name => "index_authors_on_author_url", :unique => true

  create_table "search_concepts", :force => true do |t|
    t.string   "name"
    t.string   "terms"
    t.boolean  "is_node"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "ancestry"
    t.boolean  "navigation_node"
  end

  add_index "search_concepts", ["ancestry"], :name => "index_search_concepts_on_ancestry"
  add_index "search_concepts", ["navigation_node"], :name => "index_search_concepts_on_navigation_node"

  create_table "searches", :force => true do |t|
    t.string   "search_concept_id"
    t.string   "location"
    t.string   "context_terms"
    t.string   "second_language"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "search_name"
    t.string   "date_range"
    t.integer  "notification_count"
    t.boolean  "active_search",      :default => false
    t.string   "thumbnail"
    t.string   "geolocation"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "yt_search_results", :force => true do |t|
    t.date     "published"
    t.date     "updated"
    t.string   "title"
    t.text     "description"
    t.string   "thumbnails"
    t.integer  "search_id"
    t.string   "embed_url"
    t.string   "author_name"
    t.string   "author_url"
    t.string   "category"
    t.string   "keywords"
    t.string   "player_url"
    t.integer  "duration"
    t.integer  "viewcount"
    t.string   "geo"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "video_id"
    t.boolean  "notify_new",                                          :default => false
    t.integer  "author_id"
    t.decimal  "geo_rank",              :precision => 6, :scale => 4, :default => 1.0,   :null => false
    t.decimal  "search_terms_rank",     :precision => 6, :scale => 4, :default => 1.0,   :null => false
    t.decimal  "location_mention_rank", :precision => 6, :scale => 4, :default => 1.0,   :null => false
    t.decimal  "trusted_uploader_rank", :precision => 6, :scale => 4, :default => 1.0,   :null => false
    t.decimal  "ahp_rank",              :precision => 6, :scale => 4, :default => 1.0,   :null => false
  end

  add_index "yt_search_results", ["video_id"], :name => "index_yt_search_results_on_video_id", :unique => true

end
