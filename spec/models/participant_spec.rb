require 'spec_helper'

describe Participant do

  before(:each) do
    @user = Factory(:user)
    @event = Factory(:event)

    #user creates his/her event
    @participant = @user.participants.build(:event_id => @event.id,
                                            :votes_remaining => @event.starting_votes)
  end

  it "should create a new instance given valid attributes" do
    @participant.save!
  end


  describe "user methods" do
    
    it "should have a user_id attribute" do
      @participant.should respond_to(:user_id)
    end

    it "should have the right user_id" do
      @participant.user.should == @user
    end


  end


  describe "event methods" do
    
    it "should have an event_id attribute" do
      @participant.should respond_to(:event_id)
    end

    it "should have the correct event_id" do
      @participant.event.should == @event
    end

  end


  describe "votes attributes" do

    it "should have a 'votes_remaining' attribute" do
      @participant.should respond_to(:votes_remaining)
    end

  end


  describe "validations" do
    
    before(:each) do
      @attr = {:user_id => 1, :event_id => 1, :votes_remaining => 20}
    end


    it "should require a nonblank user_id" do
      @user.participants.new(@attr.merge(:user_id => "")).should_not be_valid
    end

    it "should require a nonblank event_id" do
      @user.participants.new(@attr.merge(:event_id => "")).should_not be_valid
    end

    it "should require a nonblank votes_remaining" do
      @user.participants.new(@attr.merge(:votes_remaining => "")).should_not be_valid
    end


  end

end
