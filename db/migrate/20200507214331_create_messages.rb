class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
    add_index :message, [:conversation_id, :created_at]
  end
end
