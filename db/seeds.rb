# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users
user1 = User.create(username: 'alice', email: 'alice@example.com', password: 'password', private: false)
user2 = User.create(username: 'bob', email: 'bob@example.com', password: 'password', private: true)
user3 = User.create(username: 'carol', email: 'carol@example.com', password: 'password', private: false)

# FollowRequests
FollowRequest.create(sender: user1, recipient: user2, status: 'accepted')
FollowRequest.create(sender: user2, recipient: user1, status: 'pending')
FollowRequest.create(sender: user3, recipient: user2, status: 'accepted')
