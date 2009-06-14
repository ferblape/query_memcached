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

ActiveRecord::Schema.define(:version => 0) do

  create_table "accounts", :force => true do |t|
    t.integer "firm_id",      :limit => 11
    t.integer "credit_limit", :limit => 11
  end

  create_table "audit_logs", :force => true do |t|
    t.string  "message",                    :null => false
    t.integer "developer_id", :limit => 11, :null => false
  end

  create_table "author_addresses", :force => true do |t|
  end

  create_table "author_favorites", :force => true do |t|
    t.integer "author_id",          :limit => 11
    t.integer "favorite_author_id", :limit => 11
  end

  create_table "authors", :force => true do |t|
    t.string  "name",                                  :null => false
    t.integer "author_address_id",       :limit => 11
    t.integer "author_address_extra_id", :limit => 11
  end

  create_table "auto_id_tests", :primary_key => "auto_id", :force => true do |t|
    t.integer "value", :limit => 11
  end

  create_table "binaries", :force => true do |t|
    t.binary "data"
  end

  create_table "binary_fields", :force => true do |t|
    t.binary "tiny_blob",   :limit => 255
    t.binary "normal_blob"
    t.binary "medium_blob", :limit => 16777215
    t.binary "long_blob",   :limit => 2147483647
    t.text   "tiny_text"
    t.text   "normal_text"
    t.text   "medium_text", :limit => 2147483647
    t.text   "long_text",   :limit => 2147483647
  end

  create_table "books", :force => true do |t|
    t.string "name"
  end

  create_table "booleantests", :force => true do |t|
    t.boolean "value"
  end

  create_table "categories", :force => true do |t|
    t.string  "name",                                :null => false
    t.string  "type"
    t.integer "categorizations_count", :limit => 11
  end

  create_table "categories_posts", :id => false, :force => true do |t|
    t.integer "category_id", :limit => 11, :null => false
    t.integer "post_id",     :limit => 11, :null => false
  end

  create_table "categorizations", :force => true do |t|
    t.integer "category_id", :limit => 11
    t.integer "post_id",     :limit => 11
    t.integer "author_id",   :limit => 11
  end

  create_table "circles", :force => true do |t|
  end

  create_table "citations", :force => true do |t|
    t.integer "book1_id", :limit => 11
    t.integer "book2_id", :limit => 11
  end

  create_table "clubs", :force => true do |t|
    t.string "name"
  end

  create_table "colnametests", :force => true do |t|
    t.integer "references", :limit => 11, :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer "post_id", :limit => 11, :null => false
    t.text    "body",                  :null => false
    t.string  "type"
  end

  create_table "companies", :force => true do |t|
    t.string  "type"
    t.string  "ruby_type"
    t.integer "firm_id",   :limit => 11
    t.string  "firm_name"
    t.string  "name"
    t.integer "client_of", :limit => 11
    t.integer "rating",    :limit => 11, :default => 1
  end

  create_table "computers", :force => true do |t|
    t.integer "developer",        :limit => 11, :null => false
    t.integer "extendedWarranty", :limit => 11, :null => false
  end

  create_table "courses", :force => true do |t|
    t.string "name"
  end

  create_table "customers", :force => true do |t|
    t.string  "name"
    t.integer "balance",         :limit => 11, :default => 0
    t.string  "address_street"
    t.string  "address_city"
    t.string  "address_country"
    t.string  "gps_location"
  end

  create_table "developers", :force => true do |t|
    t.string   "name"
    t.integer  "salary",     :limit => 11, :default => 70000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers_projects", :id => false, :force => true do |t|
    t.integer "developer_id", :limit => 11,                :null => false
    t.integer "project_id",   :limit => 11,                :null => false
    t.date    "joined_on"
    t.integer "access_level", :limit => 11, :default => 1
  end

  create_table "edges", :force => true do |t|
    t.integer "source_id", :limit => 11, :null => false
    t.integer "sink_id",   :limit => 11, :null => false
  end

  add_index "edges", ["source_id", "sink_id"], :name => "unique_edge_index", :unique => true

  create_table "entrants", :force => true do |t|
    t.string  "name",                    :null => false
    t.integer "course_id", :limit => 11, :null => false
  end

  create_table "fk_test_has_fk", :force => true do |t|
    t.integer "fk_id", :limit => 11, :null => false
  end

  add_index "fk_test_has_fk", ["fk_id"], :name => "fk_name"

  create_table "fk_test_has_pk", :force => true do |t|
  end

  create_table "funny_jokes", :force => true do |t|
    t.string "name"
  end

  create_table "guids", :force => true do |t|
    t.string "key"
  end

  create_table "inept_wizards", :force => true do |t|
    t.string "name", :null => false
    t.string "city", :null => false
    t.string "type"
  end

  create_table "integer_limits", :force => true do |t|
    t.integer "c_int_without_limit", :limit => 11
    t.integer "c_int_1",             :limit => 11
    t.integer "c_int_2",             :limit => 20
    t.integer "c_int_3",             :limit => 11
    t.integer "c_int_4",             :limit => 11
    t.integer "c_int_5",             :limit => 11
    t.integer "c_int_6",             :limit => 11
    t.integer "c_int_7",             :limit => 11
    t.integer "c_int_8",             :limit => 11
  end

  create_table "items", :force => true do |t|
    t.integer "name", :limit => 11
  end

  create_table "jobs", :force => true do |t|
    t.integer "ideal_reference_id", :limit => 11
  end

  create_table "keyboards", :primary_key => "key_number", :force => true do |t|
    t.string "name"
  end

  create_table "legacy_things", :force => true do |t|
    t.integer "tps_report_number", :limit => 11
    t.integer "version",           :limit => 11, :default => 0, :null => false
  end

  create_table "lock_without_defaults", :force => true do |t|
    t.integer "lock_version", :limit => 11
  end

  create_table "lock_without_defaults_cust", :force => true do |t|
    t.integer "custom_lock_version", :limit => 11
  end

  create_table "mateys", :id => false, :force => true do |t|
    t.integer "pirate_id", :limit => 11
    t.integer "target_id", :limit => 11
    t.integer "weight",    :limit => 11
  end

  create_table "members", :force => true do |t|
    t.string "name"
  end

  create_table "memberships", :force => true do |t|
    t.datetime "joined_on"
    t.integer  "club_id",   :limit => 11
    t.integer  "member_id", :limit => 11
    t.boolean  "favourite",               :default => false
    t.string   "type"
  end

  create_table "minimalistics", :force => true do |t|
  end

  create_table "mixed_case_monkeys", :primary_key => "monkeyID", :force => true do |t|
    t.integer "fleaCount", :limit => 11
  end

  create_table "mixins", :force => true do |t|
    t.integer  "parent_id",  :limit => 11
    t.integer  "pos",        :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lft",        :limit => 11
    t.integer  "rgt",        :limit => 11
    t.integer  "root_id",    :limit => 11
    t.string   "type"
  end

  create_table "movies", :primary_key => "movieid", :force => true do |t|
    t.string "name"
  end

  create_table "non_poly_ones", :force => true do |t|
  end

  create_table "non_poly_twos", :force => true do |t|
  end

  create_table "numeric_data", :force => true do |t|
    t.decimal "bank_balance",                              :precision => 10, :scale => 2
    t.decimal "big_bank_balance",                          :precision => 15, :scale => 2
    t.integer "world_population",            :limit => 11
    t.integer "my_house_population",         :limit => 6
    t.decimal "decimal_number_with_default",               :precision => 3,  :scale => 2, :default => 2.78
  end

  create_table "orders", :force => true do |t|
    t.string  "name"
    t.integer "billing_customer_id",  :limit => 11
    t.integer "shipping_customer_id", :limit => 11
  end

  create_table "owners", :primary_key => "owner_id", :force => true do |t|
    t.string "name"
  end

  create_table "paint_colors", :force => true do |t|
    t.integer "non_poly_one_id", :limit => 11
  end

  create_table "paint_textures", :force => true do |t|
    t.integer "non_poly_two_id", :limit => 11
  end

  create_table "parrots", :force => true do |t|
    t.string   "name"
    t.string   "parrot_sti_class"
    t.integer  "killer_id",        :limit => 11
    t.datetime "created_at"
    t.datetime "created_on"
    t.datetime "updated_at"
    t.datetime "updated_on"
  end

  create_table "parrots_pirates", :id => false, :force => true do |t|
    t.integer "parrot_id", :limit => 11
    t.integer "pirate_id", :limit => 11
  end

  create_table "parrots_treasures", :id => false, :force => true do |t|
    t.integer "parrot_id",   :limit => 11
    t.integer "treasure_id", :limit => 11
  end

  create_table "people", :force => true do |t|
    t.integer "lock_version", :limit => 11, :default => 0, :null => false
    t.string  "first_name",   :limit => 40
  end

  create_table "pets", :primary_key => "pet_id", :force => true do |t|
    t.string  "name"
    t.integer "owner_id", :limit => 11
    t.integer "integer",  :limit => 11
  end

  create_table "pirates", :force => true do |t|
    t.string   "catchphrase"
    t.integer  "parrot_id",   :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "posts", :force => true do |t|
    t.integer "author_id",      :limit => 11
    t.string  "title",                                       :null => false
    t.text    "body",                                        :null => false
    t.string  "type"
    t.integer "comments_count", :limit => 11, :default => 0
    t.integer "taggings_count", :limit => 11, :default => 0
  end

  create_table "price_estimates", :force => true do |t|
    t.string  "estimate_of_type"
    t.integer "estimate_of_id",   :limit => 11
    t.integer "price",            :limit => 11
  end

  create_table "projects", :force => true do |t|
    t.string "name"
    t.string "type"
  end

  create_table "readers", :force => true do |t|
    t.integer "post_id",   :limit => 11, :null => false
    t.integer "person_id", :limit => 11, :null => false
  end

  create_table "references", :force => true do |t|
    t.integer "person_id",    :limit => 11
    t.integer "job_id",       :limit => 11
    t.boolean "favourite"
    t.integer "lock_version", :limit => 11, :default => 0
  end

  create_table "shape_expressions", :force => true do |t|
    t.string  "paint_type"
    t.integer "paint_id",   :limit => 11
    t.string  "shape_type"
    t.integer "shape_id",   :limit => 11
  end

  create_table "ships", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "created_on"
    t.datetime "updated_at"
    t.datetime "updated_on"
  end

  create_table "sponsors", :force => true do |t|
    t.integer "club_id",          :limit => 11
    t.integer "sponsorable_id",   :limit => 11
    t.string  "sponsorable_type"
  end

  create_table "squares", :force => true do |t|
  end

  create_table "subscribers", :primary_key => "nick", :force => true do |t|
    t.string "name"
  end

  add_index "subscribers", ["nick"], :name => "index_subscribers_on_nick", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.string  "subscriber_id"
    t.integer "book_id",       :limit => 11
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id",        :limit => 11
    t.integer "super_tag_id",  :limit => 11
    t.string  "taggable_type"
    t.integer "taggable_id",   :limit => 11
  end

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :limit => 11, :default => 0
  end

  create_table "tasks", :force => true do |t|
    t.datetime "starting"
    t.datetime "ending"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.string   "author_name"
    t.string   "author_email_address"
    t.datetime "written_on",                                           :null => false
    t.time     "bonus_time"
    t.date     "last_read"
    t.text     "content"
    t.boolean  "approved",                           :default => true
    t.integer  "replies_count",        :limit => 11, :default => 0
    t.integer  "parent_id",            :limit => 11
    t.string   "type"
  end

  create_table "treasures", :force => true do |t|
    t.string  "name"
    t.integer "looter_id",   :limit => 11
    t.string  "looter_type"
  end

  create_table "triangles", :force => true do |t|
  end

  create_table "vertices", :force => true do |t|
    t.string "label"
  end

  create_table "warehouse-things", :force => true do |t|
    t.integer "value", :limit => 11
  end

end
