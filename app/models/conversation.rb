class Conversation < ApplicationRecord
  belongs_to :friendship
  has_many :messages, dependent: :destroy

  def create_new_conversation(friendship)
    conversation = Conversation.new(friendship_id: friendship.id)
    conversation.save
  end
end
