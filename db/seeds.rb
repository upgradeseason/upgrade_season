# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command.
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# For users
# Bang raises exception if it doesn't work, it's a noisy method => avoids silent errors, makes debugging easier
#User.create!(name:  "Example User",
#             email: "exampleuser@upgradeseason.com",
#             password:              "foobar",
#             password_confirmation: "foobar",
#             admin:                 true,
#             activated:             true,
#             activated_at: Time.zone.now)

#99.times do |n|
#  name = Faker::Name.name
#  email = "example-#{n+1}@upgradeseason.com"
#  password = "password"
#  User.create!(name: name,
#             email:  email,
#             password:              password,
#             password_confirmation: password,
#             activated:             true,
#             activated_at: Time.zone.now)
#
#end

# For microposts
#users = User.order(:created_at).take(6)
#users = User.order(:created_at).first(6)
#50.times do #Doesn't create big runs
#  content = Faker::Lorem.sentence(word_count: 5)
#  users.each { |user| user.microposts.create!(content: content) }
#end

# Add some code for creating following relationships (enough to create interface)
#users = User.all #Select all users in DB
#user = User.first #Pick out first one
#following = users[2..50]
#followers = users[3..40]
#following.each { |followed| user.follow(followed) } #Call user.follow for each of these users to be followed
# User follows users 3..49
#followers.each { |follower| follower.follow(user) } #Each follower should follow the user.
# Users 4 through 39 follow that user back
