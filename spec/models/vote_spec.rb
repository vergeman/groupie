require 'spec_helper'

describe Vote do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @attr = {:participant_id => 1, :place_id => 1, :vote => 1 }
    @vote = Vote.new(@attr)
  end


  it "should create a new instance w/ valid attributes" do
    vote = Vote.new(@attr)
    vote.should be_valid
  end


  describe "validation PRESENCE" do

    it "should require non-blank participant_id attribute" do
      no_participant_id = Vote.new(@attr.merge(:participant_id => ""))
      no_participant_id.should_not be_valid
    end

    it "should require non-blank place_id attribute" do
      no_place_id = Vote.new(@attr.merge(:place_id => ""))
      no_place_id.should_not be_valid
    end

  end


  describe "associations" do

    it "should have a places association" do
      @vote.should respond_to(:place)
    end

    it "should have a participant association" do
      @vote.should respond_to(:participant)
    end


  end



end
