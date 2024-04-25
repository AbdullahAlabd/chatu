class RenameNumberAndCorrectIndexesForMessages < ActiveRecord::Migration[7.1]
  def change
    # Remove user defined indexes
    remove_index :messages, name: 'index_messages_on_chat_id_and_number' if index_exists?(:messages, %i[chat_id number])
    remove_index :messages, name: 'index_messages_on_deleted_at_and_chat_id_and_number' if index_exists?(:messages,
                                                                                                         %i[deleted_at
                                                                                                            chat_id number])

    # Rename number to message_number
    rename_column :messages, :number, :message_number

    # Create new indexes
    add_index :messages, %i[chat_id message_number], unique: true
    add_index :messages, %i[deleted_at chat_id message_number]
  end
end
