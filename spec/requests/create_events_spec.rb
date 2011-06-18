require 'spec_helper'

describe "CreateEvents" do


  describe "GET /create_events" do

    before(:each) do
      @user = Factory(:user)
      visit new_user_session_path
      fill_in :username, :with => @user.username
      fill_in :password, :with => @user.password
      click_button
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
          visit new_event_path
          fill_in "Title", :with => "my_test_event"
          fill_in "Description", :with => "hello"
          fill_in "event_event_date", :with => "1-2-2011"
          fill_in "Initial Votes", :with => "20"
          click_button
      end


      it "should have a signed in user" do
        controller.should be_signed_in
      end


      it "should create a new event" do

        lambda do
          visit new_event_path
          fill_in "Title", :with => "my_test_event"
          fill_in "Description", :with => "hello"
          fill_in "event_event_date", :with => "1-2-2011"
          fill_in "Initial Votes", :with => "20"
          click_button
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

    end

  end



end
