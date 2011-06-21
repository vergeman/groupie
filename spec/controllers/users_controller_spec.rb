require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    sign_in @user
  end


  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
  end


  describe "cookie test" do

    pending "cookies via #{__FILE__}"

  end

end
