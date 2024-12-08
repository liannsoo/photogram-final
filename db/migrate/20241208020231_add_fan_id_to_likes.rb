class AddFanIdToLikes < ActiveRecord::Migration[7.1]
  def change
    add_column :likes, :fan_id, :integer
    add_index :likes, :fan_id

    add_foreign_key :likes, :users, column: :fan_id

  end
end
