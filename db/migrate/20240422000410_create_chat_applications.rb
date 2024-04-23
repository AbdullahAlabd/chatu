class CreateChatApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_applications do |t|
      t.string :token, null: false
      t.string :name, null: false
      t.integer :chats_count, null: false, default: 0, unsigned: true
      t.datetime :deleted_at, null: true, default: nil

      t.timestamps
    end
    add_index :chat_applications, :token, unique: true
    add_index :chat_applications, :deleted_at
  end
end
