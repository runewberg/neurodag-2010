class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog_post

  validates_presence_of :body
  validates_length_of :body, :maximum => 2000
  # Prevent duplicate comments.
  validates_uniqueness_of :body, :scope => [:blog_post_id, :user_id]

  def comments_count
    comments.size
  end   

  # Return true for a duplicate comment (same user and body).
  def duplicate?
    c = Comment.find_by_blog_post_id_and_user_id_and_body(post, user, body)
    # Give self the id for REST routing purposes.
    self.id = c.id unless c.nil?
    not c.nil?
  end
  
  # Check authorization for destroying comments.
  def authorized?(user)
    blog_post.user == user
  end
end