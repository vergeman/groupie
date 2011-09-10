 class UsersController < ApplicationController
   include ApplicationHelper
   before_filter :authenticate_user!
   
   def show
     @title = 'Home'

     @user = User.find(current_user.id)
     @events = @user.events

     
     add_cookie_event
   end
  
end
