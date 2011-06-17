class PlacesController < ApplicationController
  def new
    @place = Place.new
    @title = "Add Places"
  end

  def create
    @user = User.find(current_user.id)
    @participant = Participant.find_by_user_id(@user.id)

    @place = Place.create(params[:place])

    if @place.save
      flash[:success] = "Place created."
      #redirect_to(someplace_path)
    else
      render 'places/new'
    end
      
  end

  def destroy
  end

end
