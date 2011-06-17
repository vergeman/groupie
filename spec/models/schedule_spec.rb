require 'spec_helper'

describe Schedule do

  before(:each) do
    @event = Factory(:event)
    @place = Factory(:place)

    @schedule = @event.schedules.build(:place_id => @place.id)

  end


  it "should create a valid new instance w/ given attribute" do
    @schedule.save!
  end

  
  describe "schedule attributes" do

    it "should have an event_id attribute" do
      @schedule.should respond_to(:event_id)
    end

    it "should have an place_id attribute" do
      @schedule.should respond_to(:place_id)
    end


  end


  describe "event association" do

    it "should have an event association" do
      @schedule.should respond_to(:event)
    end

    it "should have the right corresponding event relation" do
      @schedule.event.should == @event
    end
    
  end


  describe "place association" do

    it "should have a place association" do
      @schedule.should respond_to(:place)
    end

    it "should have the right corresponding place relation" do
      @schedule.place.should == @place
    end
   
  end


  describe "PRESENCE validations" do

    before(:each) do
      @attr = { :event_id => 1, :place_id => 1}
    end

    it "should require a nonblank place_id" do
      @event.schedules.new(@attr.merge(:place_id => "")).should_not be_valid
    end

    it "should require a nonblank event_id" do
      @event.schedules.new(@attr.merge(:event_id => "")).should_not be_valid
    end


  end

end

