require 'spec_helper'

describe PlacesController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end


  #--these aren't GET requests
  describe "GET 'create'" do
    it "should be successful" do
      #post 'create'
      #response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      #delete 'destroy'
      #response.should be_success
    end
  end

end
