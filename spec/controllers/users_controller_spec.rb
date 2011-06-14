require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
  end

end
