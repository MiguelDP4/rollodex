class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :content, length: { minimum: 1 }
  default_scope -> { order(created_at: :desc)}
end
