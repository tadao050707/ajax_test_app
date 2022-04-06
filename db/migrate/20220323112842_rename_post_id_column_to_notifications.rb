class RenamePostIdColumnToNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :post_id, :user_id
  end
end
