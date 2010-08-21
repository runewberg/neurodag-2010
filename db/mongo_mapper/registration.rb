class Registration
  key :type, String
  belongs_to  :user
  belongs_to  :conference
  key :participate_competition, Boolean
  key :selected_for_competition, Boolean
  key :bringing_posters, Boolean
  key :plenary_speaker, Boolean
  key :payment_status, Boolean
  timestamps!          
end
