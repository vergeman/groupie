require 'spec_helper'

describe Place do


  before (:each) do
    @place = Factory(:place)
  end


  it "should create a new instance w/ valid attributes" do
    @place.should be_valid
  end


  describe "association" do

    it "should have a participants association" do
      @place.should respond_to(:participants)
    end

    it "should have a votes association" do
      @place.should respond_to(:votes)
    end

  end


  describe "validation PRESENCE" do

    it "should require a name" do
      @place.name = ""
      @place.should_not be_valid
    end
    
    
  end


  

end
