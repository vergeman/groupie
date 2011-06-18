class PlacesController < ApplicationController
  def new
    @title = "Add Places"
    @event = Event.find(params[:event_id])
    @place = @event.places.build
  end


  def create
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
    @place =  Place.find(params[:id])
  end

  def destroy
  end

end
