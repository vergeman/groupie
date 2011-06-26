class PlacesController < ApplicationController
  before_filter :authenticate_user! #, :except => [:show]

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
      flash[:error] = "Oops, there was an error"
      #render :new, :event_id => @event 
      #will have to make some place to show errors (i.e. like render :new does)
      redirect_to event_path(@event.id)
      

    end
      
  end


  def show

    if signed_in?
      @user = User.find(current_user.id)
      @events = @user.events
    end

    @place =  Place.find(params[:id])
  end



  def destroy
  end

end
