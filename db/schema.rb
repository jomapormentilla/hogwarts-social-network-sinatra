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

ActiveRecord::Schema.define(version: 2020_12_06_045937) do

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.datetime "timestamp"
    t.integer "wizard_id"
    t.integer "post_id"
  end

  create_table "houses", force: :cascade do |t|
    t.string "name"
    t.string "founder"
    t.string "head_master"
    t.string "mascot"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "timestamp"
    t.integer "wizard_id"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.string "effect"
    t.integer "price"
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "wizard_id"
    t.integer "post_id"
  end

  create_table "wands", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "wizard_id"
  end

  create_table "wizard_friends", force: :cascade do |t|
    t.integer "friend_id"
    t.integer "added_friend_id"
  end

  create_table "wizard_spells", force: :cascade do |t|
    t.integer "wizard_id"
    t.integer "spell_id"
  end

  create_table "wizards", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.integer "balance"
    t.integer "house_id"
  end

end
