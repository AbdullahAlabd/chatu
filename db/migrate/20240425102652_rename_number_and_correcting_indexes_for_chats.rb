class RenameNumberAndCorrectingIndexesForChats < ActiveRecord::Migration[7.1]
  def change
    # Remove user defined indexes
    remove_index :chats, name: 'index_chats_on_deleted_at' if index_exists?(:chats, :deleted_at)
    remove_index :chats, name: 'index_chats_on_number_and_chat_application_id' if index_exists?(:chats,
                                                                                                %i[number
                                                                                                   chat_application_id])

    # Rename number to chat_number
    rename_column :chats, :number, :chat_number

    # Create new indexes
    add_index :chats, %i[chat_application_id chat_number], unique: true
    add_index :chats, %i[deleted_at chat_application_id chat_number]
  end
end
