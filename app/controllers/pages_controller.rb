class PagesController < ApplicationController
helper_method :cookies

  def home
    @title = 'Home'
    if user_signed_in?
      redirect_to user_path(:id => current_user)
    end
  end


  def about
    @title = 'About'

    if user_signed_in?
      @user = current_user
      @events = @user.events
    end
  end


  def contact
    @title = 'Contact'

    if user_signed_in?
      @user = current_user
      @events = @user.events
    end
  end


  def how
    @title = "How it works"

    if user_signed_in?
      @user = current_user
      @events = @user.events
    end
  end


end
