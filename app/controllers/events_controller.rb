class EventsController < ApplicationController
  require 'digest'

  before_filter :authenticate_user!, :except => [:show]
  helper_method :cookies

def new
  @user = User.find(current_user.id)
  @events = @user.events

  @title = "Create Event"
  @event = Event.new
end


def create
  #hardcoding starting_votes
  start_votes = 5

  @user = User.find(current_user.id)
  @events = @user.events
  
  @event = @user.events.create(params[:event].merge(:admin_id => @user.id, 
:event_key => create_event_key(@user.id), :starting_votes => start_votes))

  if @event.save
    flash[:success] = "Event created."

    @host = request.env["HTTP_HOST"]

    UserMailer.event_email(@user, @event, @host).deliver

    redirect_to(new_event_place_path(@event))

  else
    render 'events/new'
  end

end


def show

  @place = Place.new
  @event = Event.find(params[:id])
  @places = @event.places



  if signed_in?


    #if signed in, we can take the GET param and add the event accordingly (no cookies needed)  #we need match key for auth - migrate db
    if params[:invite] 
      Participant.create(:user_id => current_user.id,
                         :event_id => params[:id], 
                         :votes_remaining => 
                         Event.find(params[:id]).starting_votes)
    #else
    #  add_cookie_event

    end


    @user = User.find(current_user.id)
    @events = @user.events

    @participants = @event.participants
    @participant = @participants.find_by_user_id(current_user)

    #set if there are nil starting votes - case: user adds an event
    if @participant.votes_remaining.nil?
      @participant.update_attributes(:votes_remaining => @event.starting_votes)
    end


    # @event = @user.events.find(params[:id])
    # @places = @events.find(params[:id]).places
  end
  #if not signed in, we want to save the event cookie so that we can add it
  #once the user signs up for an account (since we lose the GET)

  # OR we overwrite the registration controler, but theres no guarantee the URL will stay w/ the event?

  #email invite (cookie) - match to generated code
  #if params[:invite] match databse generated event key
  if params[:invite] == @event.event_key
    cookies.signed[:event] = {:value => @event.id}
  end

  
end



#we will define this once the view for events are put in place
def destroy
end


private
def create_event_key(user_id)
  Digest::SHA2.hexdigest("#{Time.now.utc}--#{user_id}")
end

end


