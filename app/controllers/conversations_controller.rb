class ConversationsController < ApplicationController
  def show
    @messages = Message.where("conversation_id = #{params[:id]}")

    @message = current_user.messages.build if user_signed_in?
  end

  def create
    user_id = params[:user_id]
    unless user_id.nil?
      if conversation_exists?(user_id)
        conversation = get_conversation(user_id)
        redirect_to conversation
      else
        friendship = friendship = Friendship.where("(user_id = #{user_id} AND friend_id = #{current_user.id}) OR ((user_id = #{current_user.id} AND friend_id = #{user_id}))").first
        conversation = Conversation.new(friendship_id: friendship.id)
        conversation.save
        redirect_to conversation
      end
    else

    end
  end

  private

  def get_conversation(user_id)
    friendship = Friendship.where("(user_id = #{user_id} AND friend_id = #{current_user.id}) OR (user_id = #{current_user.id} AND friend_id = #{user_id})").first
    Conversation.find_by(friendship_id: friendship.id)
  end

  def conversation_exists?(user_id)
    friendship = Friendship.where("(user_id = #{user_id} AND friend_id = #{current_user.id}) OR (user_id = #{current_user.id} AND friend_id = #{user_id})").first
    if friendship.nil? || Conversation.find_by(friendship_id: friendship.id).nil?
      return false
    else 
      return true
    end
  end
end
