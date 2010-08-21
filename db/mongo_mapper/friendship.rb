class Friendship
  belongs_to  :user
  has_one     :friend
  key         :status, String
  key         :accepted_at, Date
  timestamps!
end
