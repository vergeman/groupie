require 'spec_helper'

describe PagesController do
render_views

  before (:each) do
    @base_title = "Groupie"
  end



  describe "GET 'home'" do

    before (:each) do
      get :home
    end

    #home page exists
    it "should be successful" do
      response.should be_success
    end

    #correct title
    it "should have title 'home'" do
      response.should have_selector('title', :content => "#{@base_title} | Home")
    end

  end



  describe "GET 'about'" do

    before (:each) do
      get :about
    end

    #about page exists
    it "should be successful" do
      response.should be_success
    end

    #correct title
    it "should have title 'about'" do
      response.should have_selector('title', :content => "#{@base_title} | About")
    end

  end



  describe "GET 'contact'" do

    before (:each) do
      get :contact
    end

    #contact page exists
    it "should be successful" do
      response.should be_success
    end

    #correct title
    it "should have title 'contact'" do
      response.should have_selector('title', :content => "#{@base_title} | Contact")
    end
  end

end
