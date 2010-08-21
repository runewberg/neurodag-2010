class Comment
  belongs_to :user
  belongs_to :blog_post  
  key :body, Text
  timestamps!
end
