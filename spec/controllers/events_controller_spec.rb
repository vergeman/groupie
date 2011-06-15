require 'spec_helper'

describe EventsController do
  render_views

  describe "GET 'new'" do
    #form tests
    it "should have a title field" do
      get :new
      response.should have_selector("input[name='event[title]'][type='text']")
    end

    it "should have a description field" do
      get :new
      response.should have_selector("input[name='event[description]'][type='text']")
    end

    it "should have a date field" do
      get :new
      response.should have_selector("input[name='event[event_date]'][type='text']")
    end

    it "should have an initial votes field" do
      get :new
      response.should have_selector("input[name='event[starting_votes]'][type='text']")
    end

  end


  describe "POST 'create'" do



    describe 'failure' do
    end


    describe 'success' do

      before (:each) do
        @event = Factory(:event)
      end
      
      it "should have a valid factory generated variable" do
        @event.should be_valid
      end

      it "should create a user" do
        
        lambda do
          post :create, :event => @event
        end.should change(Event, :count).by(1)
        
      end

    end






  end



  describe "DELETE 'destroy'" do


  end

end
