class Post < ApplicationRecord
  belongs_to :user
  validates :user_id, presence:true
  validates :content, length: { in: 5..512}
  default_scope -> { order(created_at: :desc)}
end
