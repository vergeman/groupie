class PlacesController < ApplicationController
  before_filter :authenticate_user!

  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'json'

  def search
    key = 'AIzaSyDfKgIyvLi4KzXAAzZELPO0tWIpwW9fN-Y'
    lat = '40.718902'
    long = '-73.992249'

    @result;

    respond_to do |format|
      @search_text = params[:search_text]

      base_place_uri = URI.encode("https://maps.googleapis.com/maps/api/place/search/json?location=#{lat},#{long}&radius=15&types=bar|restaurant&name=#{@search_text}&sensor=false&key=#{key}")

      place_uri = URI.parse(base_place_uri)


      http = Net::HTTP.new(place_uri.host, place_uri.port)

      http.use_ssl = true if place_uri.scheme == "https"  # enable SSL/TLS
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http.start {
        http.request_get(place_uri.path + "?" + place_uri.query) {|res|
          @result = res.body
        }
      }
      @result = ActiveSupport::JSON.decode(@result)
      
      #array of results
      #logger.debug(@result["results"][0])
      @name = @result["results"][0]["name"]
      @reference = @result["results"][0]["reference"]


      format.js {
        render :json => @result["results"]
      }


    end


  end


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
