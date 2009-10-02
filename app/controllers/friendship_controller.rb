class FriendshipController < ApplicationController
  include ProfileHelper
  before_filter :protect, :setup_friends
  
  # Send a friend request.
  # We'd rather call this "request", but that's not allowed by Rails.
  def create
    Friendship.request(@user, @friend)
    
    UserMailer.deliver_friend_request(
      :user => @user,
      :friend => @friend,
      :user_url => profile_for(@user),
      :accept_url =>  url_for(:action => "accept",  :id => @user.screen_name),
      :decline_url => url_for(:action => "decline", :id => @user.screen_name)
    )
    flash[:notice] = "Friend request sent."
    redirect_to profile_for(@friend)
  end

  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} accepted!"
    else
      flash[:notice] = "No friendship request from #{@friend.screen_name}."
    end
    redirect_to hub_url
  end
  
  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} declined"
    else
      flash[:notice] = "No friendship request from #{@friend.screen_name}."
    end
    redirect_to hub_url
  end
  
  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship with #{@friend.screen_name}"
    end
    redirect_to hub_url
  end
  
  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} deleted!"
    else
      flash[:notice] = "You aren't friends with #{@friend.screen_name}"
    end
    redirect_to hub_url
  end

  private 
  
  def setup_friends
    @user = User.find(session[:user_id])
    @friend = User.find_by_screen_name(params[:id])
  end
end