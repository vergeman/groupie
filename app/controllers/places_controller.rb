class PlacesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @title = "Add Places"
    @user = User.find(current_user.id)
    @events = @user.events

    @event = Event.find(params[:event_id])
    
    @place = @event.places.build
  end


  def create
    @user = User.find(current_user.id)
    @events = @user.events

    @event = Event.find(params[:event_id])
    
    @place = @event.places.create(:name => params[:place][:name], 
                                  :description => params[:place][:description])
    # @place = @event
    # @place = Place.create(params[:place])


    if @place.save
      flash[:success] = "Place created."
      redirect_to event_path(@event)
    else
      render :new, :event_id => @event
    end
      
  end


  def show
    @user = User.find(current_user.id)
    @events = @user.events

    @place =  Place.find(params[:id])
  end

  def destroy
  end

end
