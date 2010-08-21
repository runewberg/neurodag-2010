class BlogPost
  belongs_to  :user
  belongs_to  :conference
  key :title, String
  key :body, Text
  timestamps!
end
