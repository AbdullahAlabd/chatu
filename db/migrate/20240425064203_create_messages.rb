class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :number, null: false, unsigned: true
      t.text :content, null: false, limit: 4000
      t.datetime :deleted_at, null: true, default: nil

      t.timestamps
    end
    add_index :messages, %i[chat_id number], unique: true
    add_index :messages, %i[deleted_at chat_id number]
  end
end
