class Rating
  key :rateable_type, String
  has_one  :rateable
  belongs_to  :user
  timestamps!
end
