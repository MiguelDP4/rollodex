class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  def friends
    friends_array = friendships.map{|friendship| friendship.friend if friendship.confirmed}
    friends_array += inverse_friendships.map{|friendship| friendship.user if friendship.confirmed}
    friends_array.compact
  end

  # Users who have yet to confirm friend requests
  def pending_friends
    friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact
  end

  # All users with pending requests bothe incoming and outgoing
  def all_pending_requests
    (pending_friends + friend_requests).flatten
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find{|friendship| friendship.user == user}
    friendship.confirmed = true
    friendship.save
  end

  def unfriend(unfriended_user)
    all_friendships = friendships.map {|friendship| friendship if friendship.confirmed}.compact
    all_friendships += inverse_friendships.map{ |friendship| friendship if friendship.confirmed }.compact
    deleted_friendship = all_friendships.map{ |friendship| friendship if friendship.friend == unfriended_user || friendship.user == unfriended_user}
    deleted_friendship[0].delete
  end

  def friend?(user)
    friends.include?(user)
  end

  def can_send_request?(user)
    !friend?(user) && user != self && !all_pending_requests.include?(user)
  end

  def has_pending_request?(user)
    friend_requests.include?(user)
  end
end
