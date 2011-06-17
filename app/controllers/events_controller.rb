class EventsController < ApplicationController
  #before_filter :authenticate_user!

def new
  @event = Event.new
  @title = "Create Event"

end


def create
  # @event = current_user.events.build(params[:event])
  @user = User.find(current_user.id)
  
  @event = @user.events.create(params[:event].merge(:admin_id => @user.id))

  if @event.save
    flash[:success] = "Event created."
    redirect_to(new_place_path)

  else
    render 'events/new'
  end

end


def show
end



#we will define this once the view for events are put in place
def destroy
end


end
