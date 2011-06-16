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
        @user = Factory(:user)
        sign_in @user

        @attr = { :title => "test",
          :description => "ho",
          :event_date => Time.now, 
          :starting_votes => 20 }

      end


      it "should have a signed in user" do
        controller.user_signed_in?.should be_true
      end
      

      it "should create an event" do
        lambda do
          # @event = Factory.build(:event) #default is create
          post :create, :event => @attr
        end.should change(Event, :count).by(1)
        
      end


      it "should create a participant" do
        lambda do
          post :create, :event => @attr
        end.should change(Participant, :count).by(1)
      end


    end






  end



  describe "DELETE 'destroy'" do


  end

end
