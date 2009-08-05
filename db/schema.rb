# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090805143945) do

  create_table "curryhouses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "postcode"
    t.string   "phone_number"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curryhouses_events", :id => false, :force => true do |t|
    t.integer "curryhouse_id"
    t.integer "event_id"
  end

  add_index "curryhouses_events", ["curryhouse_id"], :name => "index_curryhouses_events_on_curryhouse_id"
  add_index "curryhouses_events", ["event_id"], :name => "index_curryhouses_events_on_event_id"

  create_table "curryhouses_votes", :id => false, :force => true do |t|
    t.integer  "curryhouse_id"
    t.integer  "vote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "curryhouses_votes", ["curryhouse_id"], :name => "index_curryhouses_votes_on_curryhouse_id"
  add_index "curryhouses_votes", ["vote_id"], :name => "index_curryhouses_votes_on_vote_id"

  create_table "events", :force => true do |t|
    t.date     "startdate"
    t.date     "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "votingopen", :default => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
