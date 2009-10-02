class EmailController < ApplicationController
  include ProfileHelper
  before_filter :protect, :only => [ "correspond" ]

  def remind
    @title = "Mail me my login information"   
    if param_posted?(:user)
      email = params[:user][:email]
      user  = User.find_by_email(email)
      if user
        UserMailer.deliver_reminder(user)
        flash[:notice] = "Login information was sent."
        redirect_to :action => "index", :controller => "site"
      else
        flash[:notice] = "There is no user with that email address."
      end
    end
  end
  
  def correspond
    user = User.find(session[:user_id])
    recipient = User.find_by_screen_name(params[:id])
    @title = "Email #{recipient.name}"
    if param_posted?(:message)
      @message = Message.new(params[:message])
      if @message.valid?
        UserMailer.deliver_message(
          :user => user,
          :recipient => recipient,
          :message => @message,
          :user_url => profile_for(user),
          :reply_url => url_for(:action => "correspond", 
                                :id => user.screen_name)
        )      
        flash[:notice] = "Email sent."
        redirect_to profile_for(recipient)
      end
    end
  end
end