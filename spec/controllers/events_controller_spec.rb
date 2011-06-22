require 'spec_helper'

describe EventsController do
  render_views

  describe "GET 'new'" do
    before(:each) do
        @user = Factory(:user)
        sign_in @user
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create Event")
    end

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

      before (:each) do
        @user = Factory(:user)
        sign_in @user
         
        @attr = { :title => "",
          :description => "",
          :event_date => "",
          :starting_votes => "" }
      end

      it "should render the 'new' page" do
        post :create, :event => @attr
        response.should render_template('new')
      end


      it "should not create an event in the db" do

        lambda do
          post :create, :event => @attr
        end.should change(Event, :count).by(0)

      end


      it "should not create an associated participant in the db" do

        lambda do
          post :create, :event => @attr
        end.should change(Participant, :count).by(0)

      end


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
      

      it "should create an event in the db" do
        lambda do
          post :create, :event => @attr
        end.should change(Event, :count).by(1)
        
      end


      it "should create an associated participant in the db" do
        lambda do
          post :create, :event => @attr
        end.should change(Participant, :count).by(1)
      end


      it "should redirect to 'new_event_place_path'" do
        post :create, :event => @attr
        response.should redirect_to(new_event_place_path(Event.all.last.id))

      end


    end


  end


 
  describe "DELETE 'destroy'" do

    pending "add 'DELETE destroy' to #{__FILE__}"

  end


  describe "GET ':id'" do

    pending "have add place form option displayed on event summary #{__FILE__}"

  end


  describe "cookies" do

    pending "cookie tests to #{__FILE__}"

  end


  describe "event vote rendering" do

    pending "place in event should have sum of participants votes in #{__FILE__}"
  end

end
