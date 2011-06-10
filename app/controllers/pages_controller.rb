class PagesController < ApplicationController
  def home
    @title = 'Home'
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
