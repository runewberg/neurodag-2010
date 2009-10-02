class CreateAll < ActiveRecord::Migration
  def self.up
    create_table "abstracts", :force => true do |t|
      t.integer  "user_id"
      t.integer  "conference_id"
      t.string   "title"
      t.text     "body"
      t.text     "authors"
      t.timestamps          
    end

    create_table "audits", :force => true do |t|
      t.integer  "auditable_id"
      t.string   "auditable_type"
      t.integer  "user_id"
      t.string   "user_type"
      t.string   "username"
      t.string   "action"
      t.text     "changes"
      t.integer  "version",        :default => 0
      t.timestamps          
    end

    add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
    add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
    add_index "audits", ["user_id", "user_type"], :name => "user_index"

    create_table "comments", :force => true do |t|
      t.integer  "user_id"
      t.integer  "blog_post_id"
      t.text     "body"
      t.timestamps          
    end

    create_table "competitions", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.integer  "conference_id"
      t.timestamps          
    end

    create_table "conferences", :force => true do |t|
      t.string   "title"
      t.datetime "year"
      t.text     "description"
      t.text     "venue"
      t.timestamps          
    end

    create_table "faqs", :force => true do |t|
      t.integer  "user_id",           :null => false
      t.text     "schools"
      t.text     "companies"
      t.text     "books_written"
      t.text     "short_cv"
      t.text     "selected_papers"
      t.text     "work_experience"
      t.text     "job_advertisement"
      t.timestamps          
    end

    create_table "friendships", :force => true do |t|
      t.integer  "user_id"
      t.integer  "friend_id"
      t.string   "status"
      t.datetime "accepted_at"
      t.timestamps                
    end

    create_table "pages", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.integer  "conference_id"
      t.integer  "parent_id"
      t.text     "embedded_video_html"
      t.string   "v_title"
      t.text     "v_description"
      t.string   "v_url"
      t.integer  "v_height"
      t.integer  "v_width"
      t.string   "v_type"
      t.timestamps
    end

    create_table "posters", :force => true do |t|
      t.string   "title"
      t.text     "abstract"
      t.text     "authors"
      t.text     "affiliations"
      t.text     "corresponding_author"
      t.integer  "registration_id"
      t.integer  "user_id"
      t.integer  "conference_id"
      t.timestamps
    end

    create_table "blog_posts", :force => true do |t|
      t.integer  "user_id"
      t.integer  "conference_id"
      t.string   "title"
      t.text     "body"
      t.timestamps    
    end

    create_table "rates", :force => true do |t|
      t.integer  "user_id"
      t.integer  "rateable_id"
      t.string   "rateable_type"
      t.integer  "stars"
      t.string   "dimension"
      t.timestamps      
    end

    add_index "rates", ["rateable_id"], :name => "index_rates_on_rateable_id"
    add_index "rates", ["user_id"], :name => "index_rates_on_user_id"

    create_table "ratings", :force => true do |t|
      t.integer  "rating",                      :default => 0
      t.string   "rateable_type", :limit => 15, :default => "", :null => false
      t.integer  "rateable_id",                 :default => 0,  :null => false
      t.integer  "user_id",                     :default => 0,  :null => false
      t.timestamps      
    end

    add_index "ratings", ["user_id"], :name => "fk_ratings_user"

    create_table "registrations", :force => true do |t|
      t.string   "type"
      t.integer  "user_id"
      t.integer  "conference_id"
      t.boolean  "participate_competition"
      t.boolean  "selected_for_competition"
      t.boolean  "bringing_posters"
      t.boolean  "plenary_speaker"
      t.boolean  "payment_status"
      t.timestamps          
    end

    create_table "sessions", :force => true do |t|
      t.string   "session_id"
      t.text     "data"
      t.datetime "updated_at"
    end

    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

    create_table :simple_captcha_data do |t|
      t.string :key, :limit => 40
      t.string :value, :limit => 6
      t.timestamps
    end

    create_table "talks", :force => true do |t|
      t.string   "title"
      t.text     "abstract"
      t.integer  "registration_id"
      t.integer  "conference_id"
      t.integer  "user_id"
      t.timestamps          
    end

    create_table "users", :force => true do |t|
      t.string   "screen_name"
      t.string   "email"
      t.string   "password"
      t.string   "authorization_token"
      t.string   "role"
      t.string   "first_name",          :default => ""
      t.string   "middle_name",         :default => ""
      t.string   "last_name",           :default => ""
      t.string   "occupation",          :default => ""
      t.string   "phone_no",            :default => ""
      t.string   "title",               :default => ""
      t.string   "city",                :default => ""
      t.boolean   "hide_contact_info",  :default => false
      t.timestamps          
    end
  
  end

  def self.down
    drop_table :users
  end

end