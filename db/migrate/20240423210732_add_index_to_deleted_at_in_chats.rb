class AddIndexToDeletedAtInChats < ActiveRecord::Migration[7.1]
  def change
    add_index :chats, :deleted_at
  end
end
