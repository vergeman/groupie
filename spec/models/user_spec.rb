require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :username => "Test_User", 
      :email => "Test_User@test.com",
      :password => "test1234" }    
  end


  describe "object creation PRESENCE validations:" do

    #general validity
    it "should create a new instance with valid attributes" do
      User.create!(@attr)
    end

    #username
    it "should have username presence" do
      no_username_user = User.new(@attr.merge(:username => ""))
      no_username_user.should_not be_valid
    end

    #email
    it "should have email presence" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    #password
    it "should have password presence" do
      no_password_user = User.new(@attr.merge(:password => ""))
      no_password_user.should_not be_valid
    end

  end


  describe "object creation LENGTH validations:" do
    
    #password
    it "password should be greater or equal to 6" do
      password_user = User.new(@attr.merge(:password => "hi"))
      password_user.should_not be_valid
    end
    
  end
  

  describe "object creation FORMAT validations:" do

    #email
    it "should have properly formatted email" do
      email_user = User.new(@attr.merge(:email => "blah"))
      email_user.should_not be_valid
    end
  
  end


  describe "object creation UNIQUE validations:" do

    #username
    it "should have no duplication in username or email" do
      user1 = User.create!(@attr)
      user2 = User.new(@attr.merge(:username => "1234567",
                                   :email => "alphabet@city.com"))
      user2.should be_valid
    end
    

    it "should have no duplicate usernames" do
      user1 = User.create!(@attr)
      user2 = User.new(@attr)
      user2.should_not be_valid
    end

    it "should have no case-insensitive duplicate usernames" do
      user1 = User.create!(@attr)
      user2 = User.new(@attr.merge(:username => @attr[:username].upcase) )
      user2.should_not be_valid
    end
        
    #email
    it "should have no case-insensitive duplicate emails" do
      user1 = User.create!(@attr)
      user2 = User.new(@attr.merge(:email => @attr[:email].upcase) )
      user2.should_not be_valid
    end
    
  end


  describe "object creation SECURITY checks" do

    it "should have matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "bleh")).should_not be_valid
    end
    

    describe "new User object consistency" do
      
      before(:each) do
        # @user = User.create!(@attr)
        @user = Factory(:user)
      end

      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end

      it "should have different encrypted / input passwords" do
        @user.encrypted_password != @user.password
      end

    end


  end



#association Participant check
  describe "participants" do
    
    before(:each) do
      @user = User.create!(@attr)
    end


    it "should have a participants method" do
      @user.should respond_to(:participants)
    end


  end
end
