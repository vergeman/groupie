require 'spec_helper'

describe Event do

  before (:each) do
    @event = Factory(:event)
  end


  describe "participants associations" do

    it "should have a participants method" do
      @event.should respond_to(:participants)
    end

  end

  describe "model validations" do

    it "should require admin_id" do
      @attr = { :admin_id => "" }
      Event.new(@attr).should_not be_valid
    end

    it "should not have a blank title" do
      @attr = { :title => "" }
      Event.new(@attr).should_not be_valid
    end

  end

  describe "user creation of event" do

    before (:each) do
      @user = Factory(:user)
      @user.save!
      @event = @user.events.create(:admin_id => @user.id,
                                   :title => "Test_Title", 
                                   :description => "Test_Description",
                                   :event_date => Time.now + 7.days,
                                   :starting_votes => 20)


      #is there a more elegant way to do this? (internal to class?)
      @event.admin_id = @user.id
    end


    describe "should have valid join in participants" do

      it "event should be saved" do
        Event.all.count.should be > 0
      end

      it "user should be saved" do
        User.all.count.should be > 0
      end

      it "with record generated" do
        Participant.all.count.should be > 0
      end

      it "with proper event_id foreign key" do
        Participant.find_by_event_id(@event.id).should_not be_nil
      end

      it "with proper user_id foreign key" do
        Participant.find_by_user_id(@user.id).should_not be_nil
      end

      it "with admin_id matching user_id" do
        @event.admin_id.should be_equal(@user.id)
      end

    end

  end


end
