class Abstract
  belongs_to User
  belongs_to Conference  
  key :title, String
  key :authors, String  
  key :body, Text
  timestamps!
end
