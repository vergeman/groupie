Factory.define :user do |user|
  user.username "Test_User"
  user.email "Test_User@test.com"
  user.password "test1234"
  user.password_confirmation "test1234"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :username do |n|
  "person-#{n}_username"
end

Factory.define :event do |event|
  event.title "Test Drink Night"
  event.admin_id 1
  event.description "Lets get crunked (test)"
  event.event_date Time.now + 7.days
  event.starting_votes 20
end

Factory.define :place do |place|
  place.name "Test locale"
  place.description "a test location used for factory girl test"
end
