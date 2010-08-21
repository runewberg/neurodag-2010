class Talk
  key :title, String
  key :abstract, Text
  belongs_to  :registration
  belongs_to  :conference
  belongs_to  :user
  timestamps!
end
