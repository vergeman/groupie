class EventsController < ApplicationController

def new
  @event = Event.new
  @title = "Create Event"

end


def create
  @event = current_user.events.build(params[:event])
  @event.id = current_user.id
#  if (@event.save!)
#    flash[:success] = "Event created."
    #redirect to items
#  else
#    render 'new'
#  end
end


def destroy
end


end
