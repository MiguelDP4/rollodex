class FriendshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    if params[:friendship_action] == 'invite'
      flash[:primary] = "Sent request to user #{user.username}"
      user_friendships = current_user.friendships
      user_friendships += current_user.inverse_friendships
      user_friendships = user_friendships.map { |friendship| friendship if friendship.friend == user || friendship.user == user }

      if user_friendships.first.nil?
        @friendship = Friendship.new(user_id: current_user.id, friend_id: user.id)
      else
        @friendship = user_friendships.first
        @friendship.delete
        @friendship = Friendship.new(user_id: current_user.id, friend_id: user.id)
      end
      if @friendship.save
        redirect_to user
      else
        redirect_to users_path
      end
    elsif params[:friendship_action] == 'accept'
      current_user.confirm_friend(user)
      flash[:success] = "You are now friends with #{user.username}"
      redirect_to user
    elsif params[:friendship_action] == 'reject'
      current_user.reject_request(user)
      flash[:danger] = "You rejected #{user.username}'s friend request"
      redirect_to request.referrer
    elsif params[:friendship_action] == 'unfriend'
      current_user.unfriend(user)
      flash[:danger] = "You are no longer friends with #{user.username}"
      redirect_to request.referrer
    elsif params[:friendship_action] == 'cancel-request'
      current_user.cancel_request(user)
      flash[:danger] = "Your friend request to #{user.username} was cancelled"
      redirect_to request.referrer
    end
  end
end
