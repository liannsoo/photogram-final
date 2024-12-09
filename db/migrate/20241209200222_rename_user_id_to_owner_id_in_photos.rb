class RenameUserIdToOwnerIdInPhotos < ActiveRecord::Migration[6.0]
  def change
    rename_column :photos, :user_id, :owner_id
  end
end
