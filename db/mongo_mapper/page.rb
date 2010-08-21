class Page
  belongs_to :conference
  belongs_to :parent_page, :class => Page
  key :title, String
  key :body,  Text

  has_many :videos
  has_many :pictures
  timestamps!
end