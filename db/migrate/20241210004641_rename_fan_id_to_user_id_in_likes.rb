class RenameFanIdToUserIdInLikes < ActiveRecord::Migration[7.1]
  def change
    rename_column :likes, :user_id, :fan_id
  end
end
