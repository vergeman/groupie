require 'spec_helper'
#include Devise::TestHelpers, :type => :controller

describe "Devises" do
#To mimic session tests

  describe "Login" do
    
    describe "success" do

      before(:each) do
        user = Factory(:user)
        visit new_user_session_path
        fill_in :username, :with => user.username
        fill_in :password, :with => user.password
        click_button
      end

=begin
      it "should sign a user in and out" do
        controller.should be_signed_in
        click_link "Logout"
        controller.should_not be_signed_in
      end
    

      it "should redirect to a signed in users home page" do
        controller.should be_signed_in
        response.should render_template('users/show')
      end
=end

    end


    describe "failure" do

      before(:each) do
        visit new_user_session_path
        fill_in :username, :with => ""
        fill_in :password, :with => ""
        click_button
      end

      it "should not sign an invalid user in" do
        controller.should_not be_signed_in
      end

=begin
      it "should respond with an error message" do
        response.should have_selector("div.flash.alert")
      end
=end

    end  #end failure



  end #end Login


end #end Devises
