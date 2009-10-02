module FriendshipHelper

  # Return an appropriate friendship status message.
  def friendship_status(user, friend)
    friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
    return "#{friend.name} is not your associate (yet)." if friendship.nil?
    case friendship.status
    when 'requested'
      "#{friend.name} would like to be your associate."
    when 'pending'
      "You have requested association with #{friend.name}."
    when 'accepted'
      "#{friend.name} is your association."
    end
  end
end