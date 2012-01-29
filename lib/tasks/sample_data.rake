namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
  end
end

def make_users
  User.create!(:first_name => 'Pierre',
               :last_name  => 'Lasante',
               :username   => 'plasante',
               :email      => 'plasante@email.com',
               :administrator => 1,
               :password   => '123456',
               :password_confirmation => '123456')
  50.times do |n|
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    username   = "username#{n}"
    email      = "password#{n}@email.com"
    password   = "password"
    User.create!(:first_name => first_name,
                 :last_name  => last_name,
                 :username   => username,
                 :email      => email,
                 :password   => password,
                 :password_confirmation => password)
  end
end