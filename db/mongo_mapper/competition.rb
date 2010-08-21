class Competition
  key :title, String
  key :description, Text
  belongs_to :conference
  timestamps!
end
