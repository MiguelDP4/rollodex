class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.references :friendship, null: false, foreign_key: true

      t.timestamps
    end
    add_index :conversations, [:friendship_id, :created_at]
  end
end
