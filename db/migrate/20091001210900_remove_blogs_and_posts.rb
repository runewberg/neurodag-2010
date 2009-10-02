class RemoveBlogsAndPosts < ActiveRecord::Migration
  def self.up
    drop_table :blogs
    drop_table :posts   
  end

  def self.down
    create_table "blogs", :force => true do |t|
      t.integer  "user_id"
      t.string   "title"
      t.integer  "conference_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "body"
    end
    create_table "posts", :force => true do |t|
      t.integer  "blog_id"
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    drop_table :blog_posts
  end

end
