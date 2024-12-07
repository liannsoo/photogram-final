# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users
user1 = User.create(username: 'alice', email: 'alice@example.com', password: 'password123', private: false)
user2 = User.create(username: 'bob', email: 'bob@example.com', password: 'password123', private: true)

# Photos
photo1 = Photo.create(caption: 'Beautiful sunset', user: user1) 
photo2 = Photo.create(caption: 'Great hike today!', user: user2)

if Rails.env.development?
  photo1.image.attach(io: File.open(Rails.root.join('Users/asoosai/Documents/IMG_5097-Enhanced-NR.jpg')), filename: 'swim1.jpg')
  photo2.image.attach(io: File.open(Rails.root.join('Users/asoosai/Documents/HC5.jpg')), filename: 'swim2.jpg')
end

# Likes
Like.create(photo: photo1, fan: user2)
Like.create(photo: photo2, fan: user1)

# FollowRequests
FollowRequest.create(sender: user1, recipient: user2, status: 'accepted')
FollowRequest.create(sender: user2, recipient: user1, status: 'pending')
