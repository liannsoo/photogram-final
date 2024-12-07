class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.references :user, foreign_key: true
      t.text :caption
      t.integer :likes_count

      t.timestamps
    end
  end
end
