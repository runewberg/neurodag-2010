class User  
  has_one :profile
  has_one :avatar

  key :email,                 String
  key :password,              String
  key :crypted_password,      String  
  key :authorization_token,   String
  key :hide_contact_info,     Bolean
  timestamps          
end
