
# -*- coding: utf-8 -*-
class PlacesController < ApplicationController
  before_filter :authenticate_user!

  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'json'

  require 'nokogiri'
  require 'open-uri'

  require 'thread'

  def search
    start_time = Time.now

    geocode = geolocate()

    #we should define this in a config..
    #key = 'AIzaSyDfKgIyvLi4KzXAAzZELPO0tWIpwW9fN-Y'
    key = 'AIzaSyABm4PzReSNyCARZYz0HgbD4CSAB-0v5Z8'

    #lat = '40.718902'
    #long = '-73.992249'
    lat = geocode['lat'].to_s
    long = geocode['lng'].to_s
    logger.debug("lat: #{geocode['lat']}")
    logger.debug("long: #{geocode['lng']}")

    max_results = 10

    @user = User.find(current_user.id)
    @events = @user.events

    @event_id = params[:event_id]
    @query_results = Array.new
    @cached_results = Hash.new


    #respond_to do |format|
    @search_text = params[:search_text]
    @search_text = search_text_adjust(@search_text)
    
      #base query google api
      base_place_uri = URI.encode("https://maps.googleapis.com/maps/api/place/search/json?location=#{lat},#{long}&radius=15&types=bar|restaurant&name=#{@search_text}&sensor=false&key=#{key}")

      @result = URI_request(base_place_uri)

      res_count = 0

      @result["results"].each do |res|
        #==cached result?
        if @place = Place.find_by_cid(res["id"])
          @cached_results[res["id"]] = true
        else 
          @place = Place.new(:cid => res["id"], :name => res["name"], :reference => res["reference"], :neighborhood => res["vicinity"])
        end

        #==early terminate max results
        res_count += 1;        
        if res_count > max_results
          logger.debug("too many")
          break;
        end
        
        @query_results.push(@place)

      end

      threads = [];
      @query_results.each do |q|

        #if its cached, then skip querying
        if !q.url.nil?
          next
        end
        

        threads << Thread.new(q) do 

          #==place search==
          search_detail = URI.encode("https://maps.googleapis.com/maps/api/place/details/json?reference=#{q.reference}&sensor=false&key=#{key}")

          #==update details for place search==

          #logger.debug("making connection")
          details = URI_request(search_detail)
          #logger.debug("Ending connection")

          #logger.debug("update_place_details")
          update_place_details(q, details)        

          #==parse google place page==
          #logger.debug("nokogiri connect")
          doc = Nokogiri::HTML(open(q.url))
          #logger.debug("end nokogiri connect")

          noko_update_place(doc, q)      

        end #end thread

      end #end loop

      threads.each do |t|  
        t.join 
      end      

    #sort so results w/ images are given priority
    @query_results = @query_results.sort {|x,y| y.image_links.length <=> x.image_links.length }

    logger.debug("save and push query results")
    @query_results.each do |p|
      if !@cached_results[p.cid]
        p.save!
      end
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

    #pseudo id from post request as we don't 
    #necessarily know the url before the form is posted
    @event = Event.find(params[:event])

    logger.debug @event.title

    if params[:place][:cid]
      #added from search
      @place = Place.find_by_cid(params[:place][:cid])
      @schedule = Schedule.create(:event_id => @event.id, :place_id => @place.id, :admin_id => @user.id)

    else
      #added manually
      @place = @event.places.create(:name => params[:place][:name], 
                                    :description => params[:place][:description])
      @place.external_links = Hash.new
      @place.image_links = Array.new
      @place.comments = Array.new
      @schedule = Schedule.create(:event_id => @event.id, :place_id => @place.id, :admin_id => @user.id)
    end


    if @place.save
      #flash[:success] = "Place created."
      redirect_to event_path(@event)
    else
      flash[:add_place_error] = "Oops, looks like you forgot information about the venue."
      logger.debug("Error on place creation")
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

  #hack for now...
  def search_text_adjust(search_text)

    if search_text == "bars"
      logger.debug("truncated search text")
      return "bar"
    end

    search_text
  end


  def geolocate
    neighborhood = params[:search_neighborhood]
    location_uri = URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address=#{neighborhood},NY&sensor=false")
    geocode = URI_request(location_uri)

    geocode['results'].first['geometry']['location']

  end

  #parses google api results, updates passed place obj
  def update_place_details(place, details)

    place.rating = details["result"]["rating"]
    place.url = details["result"]["url"]
    place.address = details["result"]["formatted_address"].to_s.gsub(", United States", "")
    place.address = place.address.to_s.gsub("/5", "")

  end


  #parse google place page and updates place details
  def noko_update_place(doc, place) 
    logger.debug("NOKOGIRI UPDATE: #{place.name}")

    #neighborhood
    doc.css('.pp-label').each do |link|
      if link.content == "Neighborhood"
        place.neighborhood = link.next_element.content
        #logger.debug(link.next_element.content)
      end
    end

    #price
    doc.css('.pp-headline-item .pp-headline-attribute').each do |link|
      place.price = link.content

    end

    #review links
    place.external_links = Hash.new
    #doc.css('.pp-awards-text a').each do |link|
    doc.css('.pp-story #pp-providers a').each do |link|
      place.external_links[ link.content.to_s.gsub(/[^a-zA-Z\.+\s+]/, "") ] = link['href']
      #logger.debug(@place.external_links)
    end

    #images
    place.image_links = Array.new
    doc.css('.pp-linked-photo').each do |link|
      place.image_links.push(link['src'])
    end
    # logger.debug(@place.image_links)

    #link comments - for now lets skip reviews
    #they don't seem to be very useful

    place.comments = Array.new
    #google plus rollout changed the layout..sneeaky

    #doc.css('.pp-story-item .review span').each do |link|

    #    place.comments.push(link.content.to_s.gsub(" ...", ""))

    #end

  end


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
