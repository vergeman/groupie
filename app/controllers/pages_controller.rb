class PagesController < ApplicationController

  def home
    @title = 'Home'
    if user_signed_in?
      redirect_to user_path(:id => current_user)
    end
  end


  def about
    @title = 'About'
  end

  def contact
    @title = 'Contact'
  end

  def how
    @title = "How it works"
  end


end
