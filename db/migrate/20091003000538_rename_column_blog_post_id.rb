class RenameColumnBlogPostId < ActiveRecord::Migration
  def self.up
       rename_column :comments, :post_id, :blog_post_id
  end

  def self.down
       rename_column :comments, :blog_post_id, :post_id
  end
end
