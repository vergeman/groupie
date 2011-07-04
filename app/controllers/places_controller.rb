# -*- coding: utf-8 -*-
class PlacesController < ApplicationController
  before_filter :authenticate_user!

  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'json'

  require 'nokogiri'
  require 'open-uri'

  def search
    start_time = Time.now

    key = 'AIzaSyDfKgIyvLi4KzXAAzZELPO0tWIpwW9fN-Y'
    lat = '40.718902'
    long = '-73.992249'
    max_results = 5

    respond_to do |format|
      @search_text = params[:search_text]

      base_place_uri = URI.encode("https://maps.googleapis.com/maps/api/place/search/json?location=#{lat},#{long}&radius=15&types=bar|restaurant&name=#{@search_text}&sensor=false&key=#{key}")

      @result = URI_request(base_place_uri)
      logger.debug(@result)

      res_count = 0
      @result["results"].each do |res|
        break if res_count > max_results - 1

        #==place search==
        @place = Place.new(:cid => res["id"], :name => res["name"], :reference => res["reference"], :neighborhood => res["vicinity"])

        reference = res["reference"]

        search_detail = URI.encode("https://maps.googleapis.com/maps/api/place/details/json?reference=#{reference}&sensor=false&key=#{key}")

        #probably spawn threads here 

        #==detail place search==
        @details = URI_request(search_detail)

        @place.rating = @details["result"]["rating"]
        @place.url = @details["result"]["url"]
        @place.address = @details["result"]["formatted_address"].to_s.gsub(", United States", "")

        #logger.debug(@place.address)
        #logger.debug(@details["result"]["url"])


        #==parse actual place page==
        doc = Nokogiri::HTML(open(@place.url))
        
        #price
        doc.css('.pp-headline-item .pp-headline-attribute').each do |link|
          @place.price = link.content
        end

        #reivew links
        @place.external_links = Hash.new        
        doc.css('.pp-awards-text a').each do |link|
          @place.external_links[ link.content.to_s.gsub(/[^a-zA-Z\.+\s+]/, "") ] = link['href'] 
          #logger.debug(@place.external_links)
        end

        #images


        #link comments
        doc.css('.fr-snip').each do |link|
          @place.comments = link.content
          #logger.debug(link.content)
        end



        res_count += 1
      end

      format.js {
        logger.debug("search requests took " + (Time.now - start_time).to_s)
        render :json => @details # @result["results"]
        # render :text => place_page
      }


    end


  end


#==canonical actions


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



private
  #returns json decoded resutls
  def URI_request(uri)
    @result;

    uri = URI.parse(uri)

    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS

    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.start {
      http.request_get(uri.path + "?" + uri.query) {|res|
        @result = res.body
      }
    }

    if @result[0..0] == '{'
      @result = ActiveSupport::JSON.decode(@result)
    else
      @result
    end
    #logger.debug(@result["results"][0])
  end


end
