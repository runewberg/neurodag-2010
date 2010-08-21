class Rate
  has_one  :user
  belongs_to :rateable
  key :rateable_type, String
  key :stars, Integer
  key :dimension, String
  timestamps!
end
