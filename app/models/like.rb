# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :integer
#  photo_id   :bigint
#
# Indexes
#
#  index_likes_on_fan_id    (fan_id)
#  index_likes_on_photo_id  (photo_id)
#
# Foreign Keys
#
#  fk_rails_...  (fan_id => users.id)
#  fk_rails_...  (photo_id => photos.id)
#
class Like < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user"
  belongs_to :photo

  validates :user, presence: true
  validates :photo, presence: true

  validates :photo_id, uniqueness: { scope: :fan_id }
end
