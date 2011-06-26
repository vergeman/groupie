 class UsersController < ApplicationController
#class UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!

   def show
     @title = 'Home'

    # @user = User.find(params[:id])
     @user = User.find(current_user.id)
     @events = @user.events
     
     add_cookie_event
     # @participants = @user.participants
     # @user = User.find_by_username(params[:id])
   end





   private
   
   def add_cookie_event
     if (user_signed_in? && cookies.signed[:event].nil? && cookies.signed[:event].present?)  #was set to present - may need to revert
       # logger.debug "COOKIE IS #{cookies.signed[:event]}"     
       event = cookies.signed[:event]
       Participant.create(:user_id => current_user.id,
                          :event_id => cookies.signed[:event],
                          :votes_remaining => 
                          Event.find(cookies.signed[:event]).starting_votes)
       
       cookies.delete :event

       redirect_to event_path(event)
     end

   end
end
