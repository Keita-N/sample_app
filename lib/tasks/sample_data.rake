namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    make_lessons
  end
end 

def make_users
  admin = User.create!(name: "Example User",
              email: "example@railstutorial.jp",
              password: "foobar",
              password_confirmation: "foobar",
              login_name: "ExampleUser",
              state: "active")
  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    password = "password"
    login_name = "#{name}-#{n+1}".gsub(" ", "")
    User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              login_name: login_name,
              state: "active")
  end
end

def make_microposts
  users = User.all(limit:6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each{ |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_lessons
  30.times do |n|
    name = "Lesson-#{n}"
    start = Time.now + n.hours
    ending = start + 2.hours
    Lesson.create(
      name:name,
      start: start,
      ending: ending)
  end
end