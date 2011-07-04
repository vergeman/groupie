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

    key = 'AIzaSyDfKgIyvLi4KzXAAzZELPO0tWIpwW9fN-Y'
    lat = '40.718902'
    long = '-73.992249'
    max_results = 5

    @query_results = Array.new
    @mutex = Mutex.new
    
    respond_to do |format|
      @search_text = params[:search_text]

      base_place_uri = URI.encode("https://maps.googleapis.com/maps/api/place/search/json?location=#{lat},#{long}&radius=15&types=bar|restaurant&name=#{@search_text}&sensor=false&key=#{key}")

      @result = URI_request(base_place_uri)
      # logger.debug(@result)

      res_count = 0
      # logger.debug("starting threads")


      @result["results"].each do |res|

        #cache check
        if @place = Place.find_by_cid(res["id"])
          # @mutex.synchronize {
              @query_results.push(@place)
              res_count += 1
          #  }
          next
        end

        #max result early terminate
        break if res_count > max_results - 1

      
        #==place search==
        logger.debug("place search")
        @place = Place.new(:cid => res["id"], :name => res["name"], :reference => res["reference"], :neighborhood => res["vicinity"])

        reference = res["reference"]

        search_detail = URI.encode("https://maps.googleapis.com/maps/api/place/details/json?reference=#{reference}&sensor=false&key=#{key}")

        #probably spawn threads here 

        #==detail place search==
        logger.debug("URI search request")
        @details = URI_request(search_detail)

        @place.rating = @details["result"]["rating"]
        @place.url = @details["result"]["url"]
        @place.address = @details["result"]["formatted_address"].to_s.gsub(", United States", "")
        @place.address = @place.address.to_s.gsub("/5", "")

        #logger.debug(@place.address)
        #logger.debug(@details["result"]["url"])


        #==parse actual place page==
        logger.debug("nokogiri")
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
        @place.image_links = Array.new
        doc.css('.pp-linked-photo').each do |link|
          @place.image_links.push(link['src'])
        end
        # logger.debug(@place.image_links)

        #link comments
        doc.css('.fr-snip').each do |link|
          @place.comments = link.content
          #logger.debug(link.content)
        end

          logger.debug("save and push query results")
         # @mutex.synchronize {
            @place.save!
            @query_results.push(@place)

            res_count += 1
        #}

      
      #logger.debug("end thread")
      
      end


      #logger.debug(@query_results)

      format.js {
        logger.debug("search requests took " + (Time.now - start_time).to_s)
        render :text => build_result_html(@query_results) # @query_results # @details # @result["results"]
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

  def build_result_html(query_string) 
    result = ""

    query_string.each do |place|

      result += "<div class=\"search_result\">"
      result += "#{place.name} <br />"
      result += "#{place.address} <br />"
      result += "#{place.neighborhood} <br />"
      result += "Rating: #{place.rating} <br />"
      result += place.price.nil? ? "" : "Price: #{place.price}"
      result += "</div>"

    end

    return result

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
