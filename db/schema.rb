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

ActiveRecord::Schema.define(:version => 20110409002653) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pairings", :force => true do |t|
    t.integer  "word_id"
    t.integer  "translation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pairings", ["translation_id"], :name => "index_pairings_on_translation_id"
  add_index "pairings", ["word_id"], :name => "index_pairings_on_word_id"

  create_table "words", :force => true do |t|
    t.string   "title"
    t.string   "part_of_speech"
    t.integer  "article_id"
    t.integer  "gender"
    t.integer  "rank"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "words", ["language_id"], :name => "index_words_on_language_id"
  add_index "words", ["rank"], :name => "index_words_on_rank"
  add_index "words", ["title"], :name => "index_words_on_title"

end
