Factory.define :user do |user|
    user.first_name            "Pierre"
    user.last_name             "Lasante"
    user.username              "plasante"
    user.email                 "plasante@email.com"
    user.password              "password"
    user.password_confirmation "password"
end

Factory.define :movie do |movie|
  movie.title                  "title"
  movie.description            "description"
  movie.rating                 "rating"
end

Factory.sequence :username do |n|
  "username-#{n}"
end

Factory.sequence :email do |n|
  "example#{n}@email.com"
end