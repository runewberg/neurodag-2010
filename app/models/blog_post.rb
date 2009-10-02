class BlogPost < ActiveRecord::Base
  has_many :comments, :order => "created_at", :dependent => :destroy
  
  belongs_to :user  
  belongs_to :conference    
  
  validates_presence_of :title, :body
  validates_length_of :title, :maximum => 200
  validates_length_of :body,  :maximum => 2000

  # Prevent duplicate posts.
  validates_uniqueness_of :body, :scope => [:title, :user_id]
  
  # Return true for a duplicate post (same title and body).
  def duplicate?
    blog_post = BlogPost.find_by_title_and_body(title, body)    
    !blog_post.nil?      
  end

  def author
    user
  end
  
  def author_name
    if author
      author.full_name
    else
      "-"
    end
  end  
end