class UserMailer < ActionMailer::Base
  
  def reminder(user)
    @subject      = 'Your login information at Neurodag.dk'
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @recipients   = user.email
    @from         = 'do-not-reply@neurodag.dk'
  end
  
  def message(mail)
    @subject      = mail[:message].subject
    @from         = "do-not-reply@neurodag.dk"
    @recipients   = mail[:recipient].email
    @body         = mail
  end

  def friend_request(mail)
    @subject      = "New friend request at RailsSpace.com"
    @from         = "do-not-reply@neurodag.dk"
    @recipients   = mail[:friend].email
    @body         = mail
  end
end