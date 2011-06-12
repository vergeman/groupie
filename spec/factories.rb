#factory girl for User

Factory.define :user do |user|
  user.username "Test_User"
  user.email "Test_User@test.com"
  user.password "test1234"
  user.password_confirmation "test1234"
end
