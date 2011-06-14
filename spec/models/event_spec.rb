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

  end




end
