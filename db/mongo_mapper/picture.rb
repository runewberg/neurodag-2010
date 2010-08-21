class Picture
  belongs_to :user
  belongs_to :conference

  key :title,         String 
  key :description,   Text   
  key :status,        String

  # technical
  key :file_name,     String 
  key :content_type,  String 
  key :file_size,     Integer

  timestamps!
end
