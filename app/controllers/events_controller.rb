class EventsController < ApplicationController

def new
  @event = Event.new
  @title = "Create Event"

end


def create
  @event = current_user.events.build(params[:event])
end


def destroy
end


end
