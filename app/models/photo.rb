# == Schema Information
#
# Table name: photos
#
#  id          :bigint           not null, primary key
#  caption     :text
#  likes_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_photos_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  mount_uploader :image, ImageUploader

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :user, presence: true
  validates :image, presence: true
end
