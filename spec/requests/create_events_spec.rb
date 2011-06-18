require 'spec_helper'

describe "CreateEvents" do

  describe "GET /create_events" do

    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end


    describe "failure event creation" do

      it "should not create a new event" do

        lambda do

          visit new_event_path
          fill_in "Title", :with => ""
          fill_in "Description", :with => ""
          fill_in "event_event_date", :with => ""
          fill_in "Initial Votes", :with => ""
          click_button
          response.should have_selector("div.error_explanation")

        end.should_not change(Event, :count)
      end

    end


    describe "successful event creation" do

      before(:each) do
        integration_valid_event_creation
      end


      it "should have a signed in user" do
        controller.should be_signed_in
      end


      it "should create a new event" do

        lambda do
          integration_valid_event_creation
          response.should have_selector("div.flash.success")
        end.should change(Event, :count).by(1)

      end


      it "appropriate event should be visible on user path reload in nav_bar" do

        visit user_path(@user.id)
        response.should have_selector("ul.event_title", :content => "my_test_event")

      end


      it "should be visible on user path reload in user show page" do
        visit user_path(@user.id)
        response.should have_selector("div.event", :content => "my_test_event")
      end


      it "should manifest as a nav bar link to the appropriate event" do
        visit user_path(@user.id)
        response.should have_selector(".event_title li") do |f|

          f.should have_selector("a", :href => event_path(Event.all.last.id), 
                                      :content => Event.all.last.title) 
        end

      end


      it "should have a titular link on the main display" do
        visit user_path(@user.id)
        response.should have_selector(".event_list li") do |f|
          f.should have_selector("a", :href => event_path(Event.all.last.id), 
                                      :content => Event.all.last.title) 
        end

      end



      describe "GET event/:id/" do

        before(:each) do
          @event = @user.events.last
          @place = @event.places.first
        end

        it "should be able to GET the event page" do
          visit event_path(@event.id)
          response.should be_success
          #response.should have_selector(".places", :content => @event.id)
        end

        #it "the event page should have the place name displayed" do
        #  visit event_path(@event.id)
        #  response.should have_selector("li", :content => @place.name)
        #end



      end



    end

  end



end
