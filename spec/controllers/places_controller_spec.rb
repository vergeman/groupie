require 'spec_helper'

describe PlacesController do
  render_views

  before(:each) do
    @user = Factory(:user)
    sign_in @user
    @event  = Factory(:event)
  end


  describe "GET 'new'" do
=begin
    it "should be successful" do
      get :new, :event_id => @event
      response.should be_success
    end

    it "should have the right title" do
      get :new, :event_id => @event
      response.should have_selector("title", :content => "Add Places")
    end


    #Form tests
    describe "form fields" do
      
      it "should have a name field" do
        get :new, :event_id => @event
        response.should have_selector("input[name='place[name]'][type='text']")
      end

      it "should have a description field" do
        get :new, :event_id => @event
        response.should have_selector("input[name='place[description]'][type='text']")
      end


    end
=end

  end


  #--these aren't GET requests
  describe "POST 'create'" do

    describe 'failure' do

      before(:each) do
        @place = Factory(:place)

        @attr = { :name => "", :description => ""} 
      end
=begin
      it "should render the 'new' page" do
        post :create, :event_id => @event, :place => @attr
        response.should render_template('new')
      end

      it "should not create a place in the db" do
        lambda do
          post :create, :event_id => @event, :place => @attr
        end.should change(Place, :count).by(0)
      end
=end
    end

    describe 'success' do

      before(:each) do
        @place = Factory(:place)

      end      

      it "should have a signed in user" do
        controller.user_signed_in?.should be_true
      end
=begin
      it "should create a place record in the db" do
        lambda do

          post :create, 
          :event_id => @event, 
          :place => @place

        end.should change(Place, :count).by(1)
      end

      pending "creation of places through tertirary relationship"

      #not sure about these tests yet
      it "should create an association Schedule record in the db" do
        lambda do

          post :create, 
          :event_id => @event, 
          :place => @place

        end.should change(Schedule, :count).by(1)

      end


      it "should redirect 'event/:id'" do
        post :create, :event_id => @event, :place => @place
        response.should redirect_to event_path(@event)
      end
=end
    end



  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      #delete 'destroy'
      #response.should be_success
    end
  end

end
