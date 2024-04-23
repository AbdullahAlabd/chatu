class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :messages_count, null: false, unsigned: true, default: 0
      t.integer :number, null: false, unsigned: true
      t.references :chat_application, null: false, foreign_key: true
      t.datetime :deleted_at, null: true, default: nil

      t.timestamps
    end
    add_index :chats, %i[number chat_application_id], unique: true
  end
end
