class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :posts, dependent: :destroy
  has_many :messages

  def friends
    users_friendships = Friendship.where("(user_id = #{self.id} OR friend_id = #{self.id}) AND confirmed = true")
    friends_list =  User.all.where(id: (users_friendships.pluck :user_id)).or(User.all.where(id: (users_friendships.pluck :friend_id))).where.not(id: (self.id))
  end

  # Users who have yet to confirm friend requests
  def pending_friends
    users_friendships = friendships.where("confirmed is null or confirmed = false")
    User.all.where(id: (users_friendships.pluck :user_id)).or(User.all.where(id: (users_friendships.pluck :friend_id))).where.not(id: (self.id))
  end

  # Users who have requested to be friends
  def friend_requests
    users_friendships = inverse_friendships.where("confirmed is null")
    User.all.where(id: (users_friendships.pluck :user_id)).or(User.all.where(id: (users_friendships.pluck :friend_id))).where.not(id: (self.id))
  end

  # All users with pending requests bothe incoming and outgoing
  def all_pending_requests
    users_friendships = Friendship.where("(user_id = #{self.id} OR friend_id = #{self.id}) AND (confirmed is null)")
    User.all.where(id: (users_friendships.pluck :user_id)).or(User.all.where(id: (users_friendships.pluck :friend_id))).where.not(id: (self.id))
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

  def cancel_request(unfriended_user)
    pending = friendships.map{ |friendship| friendship unless friendship.confirmed }.compact
    pending = pending.map{ |friendship| friendship if friendship.friend == unfriended_user }
    pending.first.delete
  end

  def reject_request(unfriended_user)
    pending = inverse_friendships.map{ |friendship| friendship unless friendship.confirmed }.compact
    pending = pending.map{ |friendship| friendship if friendship.user == unfriended_user }
    pending.first.confirmed = false
    pending.first.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def can_send_request?(user)
    if user != self && !friend?(user) && !all_pending_requests.include?(user)
      return true
    elsif rejected?(user)
      return true
    else
      return false
    end
  end

  def has_pending_request?(user)
    friend_requests.include?(user) && !rejected?(user)
  end

  def rejected?(user)
    pending_friendship = inverse_friendships.map { |friendship| friendship if friendship.user == user}.compact.first
    if pending_friendship.nil?
      return false
    elsif pending_friendship.confirmed == true || pending_friendship.confirmed.nil?
      return false
    elsif pending_friendship.confirmed == false
      return true
    end
  end
end
