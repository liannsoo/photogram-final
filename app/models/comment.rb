# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_photo_id  (photo_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (photo_id => photos.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :photo

  validates :body, presence: true
  validates :author, presence: true
  validates :photo, presence: true

end
