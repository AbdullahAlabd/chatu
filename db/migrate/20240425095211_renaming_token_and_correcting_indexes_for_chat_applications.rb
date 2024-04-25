class RenamingTokenAndCorrectingIndexesForChatApplications < ActiveRecord::Migration[7.1]
  def change
    # Remove user defined indexes
    remove_index :chat_applications, name: 'index_chat_applications_on_token' if index_exists?(:chat_applications,
                                                                                               :token)
    remove_index :chat_applications, name: 'index_chat_applications_on_deleted_at' if index_exists?(:chat_applications,
                                                                                                    :deleted_at)

    # Rename token to application_token
    rename_column :chat_applications, :token, :application_token

    # Create new index
    add_index :chat_applications, [:application_token], unique: true
    add_index :chat_applications, %i[deleted_at application_token]
  end
end
