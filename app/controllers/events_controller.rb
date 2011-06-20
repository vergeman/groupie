class EventsController < ApplicationController
  # before_filter :authenticate_user!

def new
  @user = User.find(current_user.id)
  @events = @user.events

  @title = "Create Event"
  @event = Event.new
end


def create
  # @event = current_user.events.build(params[:event])
  @user = User.find(current_user.id)
  @events = @user.events

  @event = @user.events.create(params[:event].merge(:admin_id => @user.id))

  if @event.save
    flash[:success] = "Event created."
    redirect_to(new_event_place_path(@event))

  else
    render 'events/new'
  end

end


def show
  @user = User.find(current_user.id)
  @events = @user.events
  @places = @events.find(params[:id]).places
end



#we will define this once the view for events are put in place
def destroy
end


end
