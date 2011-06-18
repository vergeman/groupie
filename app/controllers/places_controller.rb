class PlacesController < ApplicationController
  def new
    @title = "Add Places"
    @event = Event.find(params[:event_id])
    @place = @event.places.build


  end


  def create
    @user = User.find(current_user.id)
    
    @participant = Participant.find_by_user_id(@user.id)
    @event = Event.find(params[:event_id])
 
    @place = Place.create(params[:place])

    if @place.save
      flash[:success] = "Place created."
      #redirect_to(someplace_path)
    else
      render :new, :event_id => @event
    end
      
  end


  def show
  end

  def destroy
  end

end
