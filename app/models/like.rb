# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_photo_id  (photo_id)
#  index_likes_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (photo_id => photos.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :fan, class_name: "User", foreign_key: "fan_id"
  belongs_to :photo

  validates :fan, presence: true
  validates :photo, presence: true

  validates :photo_id, uniqueness: { scope: :fan_id }
end
