require 'spec_helper'

describe Event do


  describe "participants" do

    before (:each) do
      @event = Factory(:event)
    end

    it "should have a participants method" do
      @event.should respond_to(:participants)
    end


  end
end
