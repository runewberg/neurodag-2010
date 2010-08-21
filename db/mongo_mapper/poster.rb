class Posters
  key :title, String
  key :abstract, Text     
  key :authors, String
  key :affiliations, Text
  key :corresponding_author, String
  belongs_to  :registration
  belongs_to  :user
  belongs_to  :conference
  timestamps!
end
