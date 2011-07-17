
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

    @user = User.find(current_user.id)
    @events = @user.events

    @event_id = params[:event_id]
    @query_results = Array.new
    @detail_results =Hash.new

    threadsgiri = []
    noko_results = Hash.new
    mutex = Mutex.new

    respond_to do |format|
      @search_text = params[:search_text]

      base_place_uri = URI.encode("https://maps.googleapis.com/maps/api/place/search/json?location=#{lat},#{long}&radius=15&types=bar|restaurant&name=#{@search_text}&sensor=false&key=#{key}")

      @result = URI_request(base_place_uri)
      # logger.debug(@result)

      res_count = 0
      # logger.debug("starting threads")

      #== LOOP RESULTS ==



      #cache check
=begin
         if @place = Place.find_by_cid(res["id"])
           logger.debug("accessing cached result")

           mutex.synchronize {
            @query_results.push(@place)
          }

           res_count += 1

           next
         end

         #max result early terminate
         #break if res_count > max_results - 1
         break if @query_results.count == @results.count
=end

         @result["results"].each do |res|
          @place = Place.new(:cid => res["id"], :name => res["name"], :reference => res["reference"], :neighborhood => res["vicinity"])
          @query_results.push(@place)
        end


         logger.debug("==initial connection==")

         threads = []
         @query_results.each do |q|


          threads << Thread.new(Place, q) do 

            #==place search==
            search_detail = URI.encode("https://maps.googleapis.com/maps/api/place/details/json?reference=#{q.reference}&sensor=false&key=#{key}")

            #==detail place search==
            #logger.debug("making connection")
            details = URI_request(search_detail)
            #logger.debug("Ending connection")


          mutex.synchronize { 
              @detail_results[q.reference] = details
              logger.debug("pushed #{q.name}")
          }
          
          end #end thread

        end #end result loop

         threads.each do |t|  
          t.join 
        end      



         logger.debug("==updating query_results==")

         @query_results.each do |q|
          update_place_details(q, @detail_results[q.reference])
          #logger.debug("updated query results: #{q.name} ")
        end


         logger.debug("==nokogori updates==")


         @query_results.each do |q|

          threadsgiri << Thread.new(noko_results, q) do

          logger.debug("opening connection: #{q.url}")
          doc = Nokogiri::HTML(open(q.url))
          
          logger.debug("closing connection")


          mutex.synchronize {
            noko_results[q.url] = doc
          }
          
        end
        
      end

      threadsgiri.each do |threadg|  
        threadg.join
      end




         @query_results.each do |q|
          noko_update_place(noko_results[q.url], q )
        end






         #res_count += 1
         
         
         logger.debug("return results format.js")

         format.js {
          logger.debug("search requests took " + (Time.now - start_time).to_s)

          render :partial => 'places/search_results', :layout => false, :locals => { :query_results => @query_results, :events => @events, :event_id => @event_id }

          #logger.debug("save and push query results")
          # @query_results.each do |p|
          #  p.save!
          #end

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


      if params[:place][:cid]
        #added from search
        @place = Place.find_by_cid(params[:place][:cid])
        @schedule = Schedule.create(:event_id => @event.id, :place_id => @place.id)

      else
        #added manually
        @place = @event.places.create(:name => params[:place][:name], 
                                      :description => params[:place][:description])
      end


      #need to refactor as overrides above
      #respond_to do |format|

      #format.js {
      #  if @schedule.save || @place.save
      #flash[:success] = "Place created."
      #redirect_to event_path(@event)
      
      #   else
      #flash[:error] = "Oops, there was an error"
      # redirect_to event_path(@event.id)
      #   end
      #   render :nothing => true
      # }

      #manual addition
      # format.html {

      if @place.save
        #flash[:success] = "Place created."
        redirect_to event_path(@event)
      else
        flash[:error] = "Oops, there was an error"
        redirect_to event_path(@event.id)
      end

      #}
      #end      

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

    def update_place_details(place, details)

      place.rating = details["result"]["rating"]
      place.url = details["result"]["url"]
      place.address = details["result"]["formatted_address"].to_s.gsub(", United States", "")
      place.address = place.address.to_s.gsub("/5", "")

    end


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

      #reivew links
      place.external_links = Hash.new
      doc.css('.pp-awards-text a').each do |link|
        place.external_links[ link.content.to_s.gsub(/[^a-zA-Z\.+\s+]/, "") ] = link['href']
        #logger.debug(@place.external_links)
      end

      #images
      place.image_links = Array.new
      doc.css('.pp-linked-photo').each do |link|
        place.image_links.push(link['src'])
      end
      # logger.debug(@place.image_links)

      #link comments
      place.comments = Array.new
      doc.css('.fr-snip').each do |link|
        place.comments.push(link.content.to_s.gsub(" ...", ""))

        #logger.debug(link.content)
      end

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
