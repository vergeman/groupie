require 'spec_helper'

describe PlacesController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Add Places")
    end


    #Form tests
    describe "form fields" do
      
      it "should have a name field" do
        get :new
        response.should have_selector("input[name='place[name]'][type='text']")
      end

      it "should have a description field" do
        get :new
        response.should have_selector("input[name='place[description]'][type='text']")
      end


    end


  end


  #--these aren't GET requests
  describe "POST 'create'" do

    describe 'failure' do

      before(:each) do
        @place = Factory(:place)
        @user = Factory(:user)
        sign_in @user

        @attr = { :name => "", :description => ""} 
      end

      it "should render the 'new' page" do
        post :create, :place => @attr
        response.should render_template('new')
      end

      it "should not create a place in the db" do
        lambda do
          post :create, :place => @attr
        end.should change(Place, :count).by(0)
      end

    end

    describe 'success' do

      before(:each) do
        @place = Factory(:place)
        @user = Factory(:user)
        sign_in @user
      end      

      it "should have a signed in user" do
        controller.user_signed_in?.should be_true
      end

      it "should create a place record in the db" do
        lambda do
          post :create, :place => { :name => @place.name, :description => @place.description }
        end.should change(Place, :count).by(1)
      end

      pending "creation of places through tertirary relationship"

      #not sure about these tests yet
      it "should create an associated Vote record in the db" do
      end


      it "should redirect 'somwehre'" do
      end

    end



  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      #delete 'destroy'
      #response.should be_success
    end
  end

end
